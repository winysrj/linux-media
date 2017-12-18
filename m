Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38191 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752998AbdLROLT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 09:11:19 -0500
Date: Mon, 18 Dec 2017 12:11:13 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 02/17] media: v4l2-common: get rid of v4l2_routing
 dead struct
Message-ID: <20171218121113.4f50b6d7@vento.lan>
In-Reply-To: <84ee3a09-dec8-286e-94ce-7adf31f766a5@xs4all.nl>
References: <cover.1506548682.git.mchehab@s-opensource.com>
        <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
        <84ee3a09-dec8-286e-94ce-7adf31f766a5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 15:24:34 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > ---
> >  include/media/v4l2-common.h | 14 +++++---------
> >  1 file changed, 5 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> > @@ -238,11 +239,6 @@ struct v4l2_priv_tun_config {
> >  
> >  #define VIDIOC_INT_RESET            	_IOW ('d', 102, u32)  

> 
> Regarding this one: I *think* (long time ago) that the main reason for this
> was to reset a locked up IR blaster. I wonder if this is still needed after
> Sean's rework of this. Once that's all done and merged this would probably
> merit another look to see if it can be removed.

Sean,

Could you please double-check if this is still required on RC?


Thanks,
Mauro
