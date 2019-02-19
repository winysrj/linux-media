Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F64C10F00
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7531B21848
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="cqipvIE5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfBSQ1x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:27:53 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49408 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbfBSQ1x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 11:27:53 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 11B4F329;
        Tue, 19 Feb 2019 17:27:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550593672;
        bh=IHeoPL87dk6Uj1ERE8hxF4Z8/jHj09DxlJ8XbmVbavU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cqipvIE5B/2Juq4MucdrFUedmxl6rCasKERSTvCdvbZBFhOUaOBOUHvjnJkLg+9Dz
         U8Mk1bLlqFO+6KKT0ZcQYShKRadSxijHL6yFxScpMJAh4CB+NYpast++tm0KZ0iHD4
         9YNFq5wa0fN+nNBcKHV3AocpGN6Gp8BIJjgE/3VI=
Date:   Tue, 19 Feb 2019 18:27:48 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] Add support to reset device controls
Message-ID: <20190219162748.GC3526@pendragon.ideasonboard.com>
References: <20181203120331.4097-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181203120331.4097-1-kieran.bingham@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thank you for the patch.

On Mon, Dec 03, 2018 at 12:03:31PM +0000, Kieran Bingham wrote:
> Provide a new option '--reset-controls' which will enumerate the
> available controls on a device or sub-device, and re-initialise them to
> defaults.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> ---
> 
> This 'extends' the video_list_controls() function with an extra bool
> flag for 'reset' to prevent duplicating the iteration functionality.
> 
> The patch could also pass the same flag into 'video_print_control()'
> rather than implementing 'video_reset_control()' which necessitates
> calling query_control() a second time.
> 
> I have chosen to add the extra call, as I feel it makes the code
> cleaner, and pollutes the existing implementation less. The cost of the
> extra query, while a little redundant should be minimal and produces a
> simple function to reset the control independently.

I think we can do a bit better by separating control
enumeration/iteration and control print, to implement reset on top of a
function that would do enumeration/iteration only. I've sent two patches
in reply to this mail thread.

> ---
>  yavta.c | 41 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index c7986bd9e031..30022c45ed5b 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -1186,7 +1186,28 @@ static int video_print_control(struct device *dev, unsigned int id, bool full)
>  	return query.id;
>  }
>  
> -static void video_list_controls(struct device *dev)
> +static int video_reset_control(struct device *dev, unsigned int id)
> +{
> +	struct v4l2_queryctrl query;
> +	int ret;
> +
> +	ret = query_control(dev, id, &query);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (query.flags & V4L2_CTRL_FLAG_DISABLED)
> +		return query.id;
> +
> +	if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS)
> +		return query.id;
> +
> +	printf("Reset control 0x%08x to %d:\n", query.id, query.default_value);
> +	set_control(dev, query.id, query.default_value);
> +
> +	return query.id;
> +}
> +
> +static void video_list_controls(struct device *dev, bool reset)
>  {
>  	unsigned int nctrls = 0;
>  	unsigned int id;
> @@ -1207,6 +1228,12 @@ static void video_list_controls(struct device *dev)
>  		if (ret < 0)
>  			break;
>  
> +		if (reset) {
> +			ret = video_reset_control(dev, id);
> +			if (ret < 0)
> +				break;
> +		}
> +
>  		id = ret;
>  		nctrls++;
>  	}
> @@ -1837,6 +1864,7 @@ static void usage(const char *argv0)
>  	printf("    --offset			User pointer buffer offset from page start\n");
>  	printf("    --premultiplied		Color components are premultiplied by alpha value\n");
>  	printf("    --queue-late		Queue buffers after streamon, not before\n");
> +	printf("    --reset-controls		Enumerate available controls and reset to defaults\n");
>  	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
>  	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
>  	printf("    --skip n			Skip the first n frames\n");
> @@ -1860,6 +1888,7 @@ static void usage(const char *argv0)
>  #define OPT_PREMULTIPLIED	269
>  #define OPT_QUEUE_LATE		270
>  #define OPT_DATA_PREFIX		271
> +#define OPT_RESET_CONTROLS	272
>  
>  static struct option opts[] = {
>  	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
> @@ -1888,6 +1917,7 @@ static struct option opts[] = {
>  	{"queue-late", 0, 0, OPT_QUEUE_LATE},
>  	{"get-control", 1, 0, 'r'},
>  	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
> +	{"reset-controls", 0, 0, OPT_RESET_CONTROLS},
>  	{"realtime", 2, 0, 'R'},
>  	{"size", 1, 0, 's'},
>  	{"set-control", 1, 0, 'w'},
> @@ -1915,6 +1945,7 @@ int main(int argc, char *argv[])
>  	int do_enum_formats = 0, do_set_format = 0;
>  	int do_enum_inputs = 0, do_set_input = 0;
>  	int do_list_controls = 0, do_get_control = 0, do_set_control = 0;
> +	int do_reset_controls = 0;
>  	int do_sleep_forever = 0, do_requeue_last = 0;
>  	int do_rt = 0, do_log_status = 0;
>  	int no_query = 0, do_queue_late = 0;
> @@ -2107,6 +2138,9 @@ int main(int argc, char *argv[])
>  		case OPT_QUEUE_LATE:
>  			do_queue_late = 1;
>  			break;
> +		case OPT_RESET_CONTROLS:
> +			do_reset_controls = 1;
> +			break;
>  		case OPT_REQUEUE_LAST:
>  			do_requeue_last = 1;
>  			break;
> @@ -2185,7 +2219,10 @@ int main(int argc, char *argv[])
>  		set_control(&dev, ctrl_name, ctrl_value);
>  
>  	if (do_list_controls)
> -		video_list_controls(&dev);
> +		video_list_controls(&dev, false);
> +
> +	if (do_reset_controls)
> +		video_list_controls(&dev, true);
>  
>  	if (do_enum_formats) {
>  		printf("- Available formats:\n");
> -- 
> 2.17.1
> 

-- 
Regards,

Laurent Pinchart
