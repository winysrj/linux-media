Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:33752 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbZIDJC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 05:02:26 -0400
Received: by pzk28 with SMTP id 28so649887pzk.27
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2009 02:02:27 -0700 (PDT)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] DVB/V4L: ov511 - export snapshot button through input layer
Date: Fri, 4 Sep 2009 02:02:15 -0700
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20090904054805.5C944526EA5@mailhub.coreip.homeip.net> <200909041037.46690.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909041037.46690.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20090904093514.233AE526EA5@mailhub.coreip.homeip.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 September 2009 01:37:46 am Laurent Pinchart wrote:
> > +     usb_make_path(udev, ov->key_phys, OV511_KEY_PHYS_SIZE);
> > +     strlcat(ov->key_phys, "/input0", OV511_KEY_PHYS_SIZE);
> 
> What about sizeof(ov->key_phys) instead of OV511_KEY_PHYS_SIZE ?

I don't really have preference.

-- 
Dmitry
