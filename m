Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:64022 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab0ANUDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 15:03:21 -0500
Received: by qyk32 with SMTP id 32so4293978qyk.4
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 12:03:20 -0800 (PST)
Message-ID: <4B4F78A4.8000103@gmail.com>
Date: Thu, 14 Jan 2010 15:03:48 -0500
From: TJ <one.timothy.jones@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Pete Eberlein <pete@sensoray.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: go7007 driver -- which program you use for capture
References: <4B47828B.9050000@gmail.com> <be3a4a1001081217s1bec67c8odb26bb793700242b@mail.gmail.com> <4B47B0EB.6000102@gmail.com> <4B4E34D2.8090202@redhat.com> <4B4E4365.5020307@gmail.com> <4B4E4550.7030907@redhat.com>
In-Reply-To: <4B4E4550.7030907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro Carvalho Chehab wrote:
> It should be against -hg or linux-next tree, otherwise, I can't send it upstream.
> If you just want to send a patch for people to test, please mark it as RFC, otherwise
> I'll assume that you're sending a patch for upstream.
> 
> Since there are more people working on this driver, the better is to add what you
> have there, to avoid people to do a similar work.

OK my brother. I got a hold of the -hg tree and started working off of it.

Pete, Question: I was looking through the code and noticed that you turned s2250
driver into v4l2_subdev and go7007 driver initializes it as such and passes it
calls via call_all (v4l2_device_call_until_err). How does that affect other
drivers? Does that mean they all need to re-written as v4l2_subdev?

-TJ

