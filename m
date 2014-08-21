Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:48389 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaHUHmb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 03:42:31 -0400
Date: Thu, 21 Aug 2014 09:42:24 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 12/29] kinect: fix sparse warnings
Message-Id: <20140821094224.68a63155e154a7419eb7ea23@ao2.it>
In-Reply-To: <1408575568-20562-13-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
	<1408575568-20562-13-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 21 Aug 2014 00:59:11 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/usb/gspca/kinect.c:151:19: warning: incorrect type in assignment (different base types)
> drivers/media/usb/gspca/kinect.c:152:19: warning: incorrect type in assignment (different base types)
> drivers/media/usb/gspca/kinect.c:153:19: warning: incorrect type in assignment (different base types)
> drivers/media/usb/gspca/kinect.c:191:13: warning: restricted __le16 degrades to integer
> drivers/media/usb/gspca/kinect.c:217:16: warning: incorrect type in assignment (different base types)
> drivers/media/usb/gspca/kinect.c:218:16: warning: incorrect type in assignment (different base types)
> 
> Note that this fixes a real bug where cpu_to_le16 was used instead of the correct
> le16_to_cpu.

Right.

A little background on why I overlooked the issue: libfreenect —which is
where the code originally comes from— uses the _same_ function for
cpu_to_* and *_to_cpu conversions, and this is practically OK on common
architectures even though it is not semantically correct.

Thanks for the fix.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Antonio Ospite <ao2@ao2.it>

> ---
>  drivers/media/usb/gspca/kinect.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
> index 45bc1f5..3cb30a3 100644
> --- a/drivers/media/usb/gspca/kinect.c
> +++ b/drivers/media/usb/gspca/kinect.c
> @@ -51,9 +51,9 @@ struct pkt_hdr {
>  
>  struct cam_hdr {
>  	uint8_t magic[2];
> -	uint16_t len;
> -	uint16_t cmd;
> -	uint16_t tag;
> +	__le16 len;
> +	__le16 cmd;
> +	__le16 tag;
>  };
>  
>  /* specific webcam descriptor */
> @@ -188,9 +188,9 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
>  		       rhdr->tag, chdr->tag);
>  		return -1;
>  	}
> -	if (cpu_to_le16(rhdr->len) != (actual_len/2)) {
> +	if (le16_to_cpu(rhdr->len) != (actual_len/2)) {
>  		pr_err("send_cmd: Bad len %04x != %04x\n",
> -		       cpu_to_le16(rhdr->len), (int)(actual_len/2));
> +		       le16_to_cpu(rhdr->len), (int)(actual_len/2));
>  		return -1;
>  	}
>  
> @@ -211,7 +211,7 @@ static int write_register(struct gspca_dev *gspca_dev, uint16_t reg,
>  			uint16_t data)
>  {
>  	uint16_t reply[2];
> -	uint16_t cmd[2];
> +	__le16 cmd[2];
>  	int res;
>  
>  	cmd[0] = cpu_to_le16(reg);
> -- 
> 2.1.0.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
