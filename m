Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48389
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757095AbdDQBj2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 21:39:28 -0400
Date: Sun, 16 Apr 2017 22:39:21 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ryan <ryanphilips19@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Camera resolution question
Message-ID: <20170416223921.0ca8b712@vento.lan>
In-Reply-To: <CANMsd01ucT7PuyUVqgGbcEGTFNjOT=cVwcppfnZd-XDpd58CZQ@mail.gmail.com>
References: <CANMsd01ucT7PuyUVqgGbcEGTFNjOT=cVwcppfnZd-XDpd58CZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Apr 2017 21:31:48 +0530
Ryan <ryanphilips19@googlemail.com> escreveu:

> Hi,
> 
> I have a display of 720P and a 8MP camera.
> 
> Do i need to capture 8MP image or an image 720P from the camera as the
> i need to display it on the LCD.
> 
> Where does the scaling take place? Should i scale the image down
> before i display or should i capture a smaller resolution image from
> the
> camera to be able to display on the LCD.

That depends on what you want ;)

If you scale the image at the camera sensor (if the sensor has
internally a downscaler), you'll likely be able to get a higher
frame rate, although those scalers are usually simple (they usually
just discards pixels and lines).

If you don't need a higher frame rate, then you can use a better
scaler that would use an algorithm that would give a better
image quality.


Thanks,
Mauro
