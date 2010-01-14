Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:23359 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0ANUR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 15:17:58 -0500
Received: by qw-out-2122.google.com with SMTP id 8so12456qwh.37
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 12:17:57 -0800 (PST)
Message-ID: <4B4F7C11.3030802@gmail.com>
Date: Thu, 14 Jan 2010 15:18:25 -0500
From: TJ <one.timothy.jones@gmail.com>
MIME-Version: 1.0
To: Pete Eberlein <pete@sensoray.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: go7007 driver -- which program you use for capture
References: <4B47828B.9050000@gmail.com>	 <be3a4a1001081217s1bec67c8odb26bb793700242b@mail.gmail.com>	 <4B47B0EB.6000102@gmail.com> <4B4E34D2.8090202@redhat.com>	 <4B4E4365.5020307@gmail.com> <4B4E4550.7030907@redhat.com>	 <4B4F78A4.8000103@gmail.com> <1263499712.4730.11.camel@pete-desktop>
In-Reply-To: <1263499712.4730.11.camel@pete-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Pete Eberlein wrote:
> On Thu, 2010-01-14 at 15:03 -0500, TJ wrote:
> 
>> Pete, Question: I was looking through the code and noticed that you turned s2250
>> driver into v4l2_subdev and go7007 driver initializes it as such and passes it
>> calls via call_all (v4l2_device_call_until_err). How does that affect other
>> drivers? Does that mean they all need to re-written as v4l2_subdev?
> 
> That is correct.  The other drivers do not work until they are all
> converted to the subdev interface.  I'm working on the other drivers
> now.  I've finished ov7640 and have started on saa7113.
> 
> Once the subdev driver conversions are completed, we should be able to
> move the go7007 driver out of staging.
> 
> Pete
> 

Cool man. I will start working on tw9903 and tw9906, as this is my main area of
interest. Is there a template for subdev driver or should I just use your s2250
as an example? -TJ
