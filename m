Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42142 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557Ab0GSLX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 07:23:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: Re: [RFC/PATCH 02/10] media: Media device
Date: Mon, 19 Jul 2010 13:23:37 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com> <AANLkTik7SaoJftra3bAUlp3AJhM4KD91w9uCOUz1xG7b@mail.gmail.com>
In-Reply-To: <AANLkTik7SaoJftra3bAUlp3AJhM4KD91w9uCOUz1xG7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007191323.38072.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

On Sunday 18 July 2010 17:32:24 Muralidharan Karicheri wrote:
> Hi Laurent,
> 
> > +++ b/Documentation/media-framework.txt
> > @@ -0,0 +1,68 @@
> > +Linux kernel media framework
> > +============================
> > +
> 
> <snip>
> 
> I felt more details needed in this media-framework.txt for information such
> as which driver call this register() /unregister() function, details on link
> management etc. I have not seen other patches yet. If it is discussed
> elsewhere, please ignore this.

I've split the documentation among the patches, adding sections that describe 
the code as new code was added. The final documentation is much more complete 
than this.

> For the first part of the question, will the v4l2 core calls this for video
> devices drivers? For other drivers such as audio, IR etc which are related
> to the video devices, how this is handled. I think such details are required
> in this documentation.

The last patches describe the relationship between the V4L2 and media 
frameworks in Documentation/video4linux/v4l2-framework.txt.

-- 
Regards,

Laurent Pinchart
