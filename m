Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4B0C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 21:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D0B206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 21:15:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="hSP4lEVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfAIVPM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 16:15:12 -0500
Received: from mail.ao2.it ([92.243.12.208]:38398 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfAIVPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 16:15:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:Content-Type:Mime-Version:References:In-Reply-To:Message-Id:Subject:Cc:To:From:Date; bh=UWiDO+ZOvm1Ekot8PNG5Uh5KMl4SYJLC0hMDy0ghoGw=;
        b=hSP4lEVVTdmPVxS9KdXA2ZfdntqnGRCr45pWU+QCE1m9iV2CmZ65xe1oaeXF4pVqoOdlaxI18Ve3IaA/D35lqAlSlY/OEEijHVLNGrOUyarvmqNtqYFC/zYmoOvPMrKvYIzSTTv/WM7dhepVvhoHlTK6KeMYu6gqYR5cb4catVvDHkAfXs7bwwfLEQ4dRMNwRr3y/qhFHMLdwzZ3myTzt6s77DFd2hbJfnTXKC5UBdJDGEwGCz5jM8AF+Znv07Z9tHtDgcZkci1USZ7F6hJLAJUe50WDDGsbio2zD6MEJCMAn8iteLngHYlUqDYaPDHyU9anDpVpwHADqS44UlqFLg==;
Received: from localhost ([::1] helo=jcn.localdomain)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1ghLAq-0002P8-LD; Wed, 09 Jan 2019 22:14:04 +0100
Date:   Wed, 9 Jan 2019 22:15:08 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] v4l2-ctl: add an option to list controls in a
 machine-readable format
Message-Id: <20190109221508.eaa19c66df252a1f9802cd9a@ao2.it>
In-Reply-To: <3f081956-7733-069b-da24-0d04831b8ed1@xs4all.nl>
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
        <20190103180102.12282-1-ao2@ao2.it>
        <20190103180102.12282-6-ao2@ao2.it>
        <3f081956-7733-069b-da24-0d04831b8ed1@xs4all.nl>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 7 Jan 2019 11:18:58 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 01/03/2019 07:01 PM, Antonio Ospite wrote:
> > Add a new option --list-ctrls-values to list the values of controls in
> > a format which can be passed again to --set-ctrl.
> > 
> > This can be useful to save and restore device settings:
> > 
> >   $ v4l2-ctl --list-ctrls-values >settings.txt 2>/dev/null
> >   $ v4l2-ctl --set-ctrl "$(cat settings.txt)"
> > 
> > The new option has been tested with the vivid driver and it works well
> > enough to be useful with a real driver as well.
> > 
> > String controls are not supported for now, as they may not be parsed
> > correctly by --set-ctrl if they contain a comma or a single quote.
> > 
> > Signed-off-by: Antonio Ospite <ao2@ao2.it>
> > ---
> >  utils/v4l2-ctl/v4l2-ctl-common.cpp | 72 ++++++++++++++++++++++++++----
> >  utils/v4l2-ctl/v4l2-ctl.1.in       |  4 ++
> >  utils/v4l2-ctl/v4l2-ctl.cpp        |  1 +
> >  utils/v4l2-ctl/v4l2-ctl.h          |  1 +
> >  4 files changed, 69 insertions(+), 9 deletions(-)
> > 
> > diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> > index 7777b45c..b4124608 100644
> > --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
> > +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
[...]
> > @@ -1102,13 +1146,23 @@ void common_get(cv4l_fd &_fd)
> >  
> >  void common_list(cv4l_fd &fd)
> >  {
> > -	if (options[OptListCtrls] || options[OptListCtrlsMenus]) {
> > -		struct print_format classic_format = {
> > -			.print_class_name = print_class_name,
> > -			.print_qctrl = print_qctrl,
> > -			.show_menus = options[OptListCtrlsMenus],
> > -		};
> > -
> > -		list_controls(fd.g_fd(), &classic_format);
> > +	if (options[OptListCtrls] || options[OptListCtrlsMenus] || options[OptListCtrlsValues]) {
> > +		if (options[OptListCtrlsValues]) {
> > +			struct print_format machine_format = {
> > +				.print_class_name = NULL,
> > +				.print_qctrl = print_qctrl_values,
> > +				.show_menus = 0,
> > +			};
> > +
> > +			list_controls(fd.g_fd(), &machine_format);
> > +		} else {
> > +			struct print_format classic_format = {
> > +				.print_class_name = print_class_name,
> > +				.print_qctrl = print_qctrl,
> > +				.show_menus = options[OptListCtrlsMenus],
> > +			};
> > +
> > +			list_controls(fd.g_fd(), &classic_format);
> > +		}
> 
> I don't like this struct print_format.
>

Hi Hans,

the idea was based on two considerations:
  1. decide the format once and for all, avoiding to check each time a
     control is printed.
  2. have at least some partial infrastructure in case some
     other export formats were to be added.

But yeah, as 2. seems quite unlikely I can go with a more essential
approach for now, no problem.

> I would prefer something like this:
> 
> Rename print_qctrl to print_qctrl_readable() and create a new print_qctrl:
> 
> static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
>                 struct v4l2_ext_control *ctrl, int show_menus)
> {
> 	if (options[OptListCtrlsValues])
> 		print_qctrl_values(fd, queryctrl, ctrl, show_menus);
> 	else
> 		print_qctrl_readable(fd, queryctrl, ctrl, show_menus);
> }
>

Since "readable" here means "human readable", while "values" is meant
for a "machine readable" output, I'd "avoid" the word "readable" at
all and go with "details" or "description":

	if (options[OptListCtrlsValues])
		print_qctrl_values(fd, queryctrl, ctrl, show_menus);
	else
		print_qctrl_details(fd, queryctrl, ctrl, show_menus);

> And in print_control you can just skip printing the class name if
> options[OptListCtrlsValues] is set.
>

OK.

> I would like to see string controls being supported. I would recommend
> to just write the string as a hexdump. It avoids having to escape characters.
> 
> The same can be done for compound/array controls. In fact, you could write
> all controls that way. It would simplify things a lot.
>

But then --set-ctrl would need to be extended to parse the hexdump,
wouldn't it? Do you already have a syntax in mind?

TBH, I kept things simple hoping to re-use --set-ctrl without too much
work.

> Also, when options[OptListCtrlsValues] is set you should skip all WRITE_ONLY
> controls, all BUTTON controls, and all volatile controls. They are not
> relevant if you are just interested in controls that can be set.
>

That I will do in any case, thank you.

> Regards,
> 
> 	Hans

Thank you,
   Antonio

-- 
Antonio Ospite
https://ao2.it
https://twitter.com/ao2it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
