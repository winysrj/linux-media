Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33483
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475Ab2IZUUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 16:20:24 -0400
Date: Wed, 26 Sep 2012 17:20:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Dror Cohen <dror@liveu.tv>, <linux-media@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 0/1 v2] media/video: vpif: fixing function name start to
 vpif_config_params
Message-ID: <20120926172016.3b6b23c4@infradead.org>
In-Reply-To: <50290B89.7070100@ti.com>
References: <1344494017-18099-1-git-send-email-dror@liveu.tv>
	<50290B89.7070100@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 13 Aug 2012 19:43:29 +0530
Manjunath Hadli <manjunath.hadli@ti.com> escreveu:

> Hi Dror,
> 
> Thanks for the patch.
> 
> Mauro,
> 
> I'll queue this patch for v3.7 through my tree.

Sure.

> 
> On Thursday 09 August 2012 12:03 PM, Dror Cohen wrote:
> > This patch address the issue that a function named config_vpif_params should
> > be vpif_config_params. However this name is shared with two structures defined
> > already. So I changed the structures to config_vpif_params (origin was
> > vpif_config_params)
> >
> > v2 changes: softer wording in description and the structs are now
> > defined without _t

Hmm... I didn't understand what you're wanting with this change. Before this patch,
there are:

v4l@pedra ~/v4l/patchwork $ git grep config_vpif_params
drivers/media/platform/davinci/vpif.c:/* config_vpif_params
drivers/media/platform/davinci/vpif.c:static void config_vpif_params(struct vpif_params *vpifparams,
drivers/media/platform/davinci/vpif.c:    config_vpif_params(vpifparams, channel_id, found);
v4l@pedra ~/v4l/patchwork $ git grep vpif_config_params
drivers/media/platform/davinci/vpif_capture.c:static struct vpif_config_params config_params = {
drivers/media/platform/davinci/vpif_capture.h:struct vpif_config_params {
drivers/media/platform/davinci/vpif_display.c:static struct vpif_config_params config_params = {
drivers/media/platform/davinci/vpif_display.h:struct vpif_config_params {

After that, there are:

v4l@pedra ~/v4l/patchwork $ git grep vpif_config_params
drivers/media/platform/davinci/vpif.c:/* vpif_config_params
drivers/media/platform/davinci/vpif.c:static void vpif_config_params(struct vpif_params *vpifparams,
drivers/media/platform/davinci/vpif.c:    vpif_config_params(vpifparams, channel_id, found);
v4l@pedra ~/v4l/patchwork $ git grep config_vpif_params
drivers/media/platform/davinci/vpif_capture.c:static struct config_vpif_params config_params = {
drivers/media/platform/davinci/vpif_capture.h:struct config_vpif_params {
drivers/media/platform/davinci/vpif_display.c:static struct config_vpif_params config_params = {
drivers/media/platform/davinci/vpif_display.h:struct config_vpif_params {

So, I can't really see any improvement on avoiding duplicate names.

IMHO, the better would be to name those functions as:

vpif:		vpif_config_params (or, even better, vpif_core_config_params)
vpif_capture:	vpif_capture_config_params
vpif_display:	vpif_display_config_params

This way, duplication will be avoided and will avoid the confusing inversion between
vpif and config.

Regards,
Mauro
