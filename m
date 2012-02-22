Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2BVM1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 07:27:11 -0500
Date: Wed, 22 Feb 2012 13:26:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Subject: Re: [PATCH] media: i.MX27 camera: Add resizing support.
In-Reply-To: <CACKLOr013RDDWuddOMfzgRGPL90skw3UMQwo=2MLdU1o5LSX-Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202221325540.3136@axis700.grange>
References: <1329219332-27620-1-git-send-email-javier.martin@vista-silicon.com> <Pine.LNX.4.64.1202201413300.2836@axis700.grange> <CACKLOr1KT2A1Zd_xsVXPGW8X6e57v6xTZTm46wdfNfwwf9-MYQ@mail.gmail.com>
 <CACKLOr013RDDWuddOMfzgRGPL90skw3UMQwo=2MLdU1o5LSX-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Feb 2012, javier Martin wrote:

> >>> @@ -1087,6 +1298,18 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
> >>>       if (ret < 0 && ret != -ENOIOCTLCMD)
> >>>               return ret;
> >>>
> >>> +     /* Store width and height returned by the sensor for resizing */
> >>> +     pcdev->s_width = mf.width;
> >>> +     pcdev->s_height = mf.height;
> >>> +     dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
> >>> +             __func__, pcdev->s_width, pcdev->s_height);
> >>> +
> >>> +     memset(pcdev->resizing, 0, sizeof(struct emma_prp_resize) << 1);
> >>
> >> I think, just sizeof(pcdev->resizing) will do the trick.
> 
> No, it doesn't work because pcdev->resizing is a pointer whose size is 
> 4bytes.

Sorry?

+	struct emma_prp_resize  resizing[2];

.resizing is an array of 2 "struct emma_prp_resize" objects.

Thanks
Guennadi

> I will just left this unchanged with your permission.
> 
> Regards.
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
