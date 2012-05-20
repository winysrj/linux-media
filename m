Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50075 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2ETWaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 18:30:14 -0400
Received: by obbtb18 with SMTP id tb18so7218304obb.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 15:30:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB95A3B.9070800@iki.fi>
References: <4FB95A3B.9070800@iki.fi>
Date: Sun, 20 May 2012 15:30:13 -0700
Message-ID: <CAA7C2qiDQJ33OTfq9WxtAgqm0+iaLANoNVKSrvbZ3JpCD=ZGrA@mail.gmail.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
From: VDR User <user.vdr@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 20, 2012 at 1:55 PM, Antti Palosaari <crope@iki.fi> wrote:
> I did some more planning and made alternative RFC.
> As the earlier alternative was more like changing old functionality that new
> one goes much more deeper.

> Functionality enhancement mentioned earlier RFC are valid too:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg46352.html

One thing I didn't see mentioned in your post or the one your linked
is the rc dependency for _all_ usb devices, whether they even have rc
capability or not. It makes sense that is dvb usb is going to get
overhauled, that rc functionality be at the very least optional rather
than forced it on all usb devices.
