Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53827 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2I0FQj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 01:16:39 -0400
Received: by obbuo13 with SMTP id uo13so1388113obb.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 22:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926172016.3b6b23c4@infradead.org>
References: <1344494017-18099-1-git-send-email-dror@liveu.tv>
 <50290B89.7070100@ti.com> <20120926172016.3b6b23c4@infradead.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 27 Sep 2012 10:46:17 +0530
Message-ID: <CA+V-a8utUAJ6B6UJP32T118YXXhCkBWe8Hg+mr6OLv-ZeDQmPA@mail.gmail.com>
Subject: Re: [PATCH 0/1 v2] media/video: vpif: fixing function name start to vpif_config_params
To: Dror Cohen <dror@liveu.tv>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dror,

On Thu, Sep 27, 2012 at 1:50 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Mon, 13 Aug 2012 19:43:29 +0530
> Manjunath Hadli <manjunath.hadli@ti.com> escreveu:
>
>> Hi Dror,
>>
>> Thanks for the patch.
>>
>> Mauro,
>>
>> I'll queue this patch for v3.7 through my tree.
>
> Sure.
>
>>
>> On Thursday 09 August 2012 12:03 PM, Dror Cohen wrote:
>> > This patch address the issue that a function named config_vpif_params should
>> > be vpif_config_params. However this name is shared with two structures defined
>> > already. So I changed the structures to config_vpif_params (origin was
>> > vpif_config_params)
>> >
>> > v2 changes: softer wording in description and the structs are now
>> > defined without _t
>
> Hmm... I didn't understand what you're wanting with this change. Before this patch,
> there are:
>
> v4l@pedra ~/v4l/patchwork $ git grep config_vpif_params
> drivers/media/platform/davinci/vpif.c:/* config_vpif_params
> drivers/media/platform/davinci/vpif.c:static void config_vpif_params(struct vpif_params *vpifparams,
> drivers/media/platform/davinci/vpif.c:    config_vpif_params(vpifparams, channel_id, found);
> v4l@pedra ~/v4l/patchwork $ git grep vpif_config_params
> drivers/media/platform/davinci/vpif_capture.c:static struct vpif_config_params config_params = {
> drivers/media/platform/davinci/vpif_capture.h:struct vpif_config_params {
> drivers/media/platform/davinci/vpif_display.c:static struct vpif_config_params config_params = {
> drivers/media/platform/davinci/vpif_display.h:struct vpif_config_params {
>
> After that, there are:
>
> v4l@pedra ~/v4l/patchwork $ git grep vpif_config_params
> drivers/media/platform/davinci/vpif.c:/* vpif_config_params
> drivers/media/platform/davinci/vpif.c:static void vpif_config_params(struct vpif_params *vpifparams,
> drivers/media/platform/davinci/vpif.c:    vpif_config_params(vpifparams, channel_id, found);
> v4l@pedra ~/v4l/patchwork $ git grep config_vpif_params
> drivers/media/platform/davinci/vpif_capture.c:static struct config_vpif_params config_params = {
> drivers/media/platform/davinci/vpif_capture.h:struct config_vpif_params {
> drivers/media/platform/davinci/vpif_display.c:static struct config_vpif_params config_params = {
> drivers/media/platform/davinci/vpif_display.h:struct config_vpif_params {
>
> So, I can't really see any improvement on avoiding duplicate names.
>
> IMHO, the better would be to name those functions as:
>
> vpif:           vpif_config_params (or, even better, vpif_core_config_params)
> vpif_capture:   vpif_capture_config_params
> vpif_display:   vpif_display_config_params
>
> This way, duplication will be avoided and will avoid the confusing inversion between
> vpif and config.
>
I agree with Mauro here, Can you do the above changes and post
a v2.( Rebase it on
http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.7
branch)

Regards,
--Prabhakar Lad

> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
