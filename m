Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.176.23]:41150 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751319Ab0ANUP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 15:15:29 -0500
Subject: Re: go7007 driver -- which program you use for capture
From: Pete Eberlein <pete@sensoray.com>
To: TJ <one.timothy.jones@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4B4F78A4.8000103@gmail.com>
References: <4B47828B.9050000@gmail.com>
	 <be3a4a1001081217s1bec67c8odb26bb793700242b@mail.gmail.com>
	 <4B47B0EB.6000102@gmail.com> <4B4E34D2.8090202@redhat.com>
	 <4B4E4365.5020307@gmail.com> <4B4E4550.7030907@redhat.com>
	 <4B4F78A4.8000103@gmail.com>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 12:08:32 -0800
Message-Id: <1263499712.4730.11.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-01-14 at 15:03 -0500, TJ wrote:

> Pete, Question: I was looking through the code and noticed that you turned s2250
> driver into v4l2_subdev and go7007 driver initializes it as such and passes it
> calls via call_all (v4l2_device_call_until_err). How does that affect other
> drivers? Does that mean they all need to re-written as v4l2_subdev?

That is correct.  The other drivers do not work until they are all
converted to the subdev interface.  I'm working on the other drivers
now.  I've finished ov7640 and have started on saa7113.

Once the subdev driver conversions are completed, we should be able to
move the go7007 driver out of staging.

Pete

