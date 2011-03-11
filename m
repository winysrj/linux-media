Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1CKSkU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 13:40:20 -0500
Message-ID: <4D7A6CFC.4050102@redhat.com>
Date: Fri, 11 Mar 2011 19:42:04 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: "Chen, Xianwen" <xianwen.chen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: What is the driver for "0c45:6413 Microdia" webcam?
References: <AANLkTik2jsKfBYjj37gXZH=h5R0DPZ5tVyXusw0Y4noi@mail.gmail.com>
In-Reply-To: <AANLkTik2jsKfBYjj37gXZH=h5R0DPZ5tVyXusw0Y4noi@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 03/11/2011 07:04 PM, Chen, Xianwen wrote:
> Hi there,
>
> I'm having a hard time locating the proper driver for "0c45:6413
> Microdia" webcam. I consulted "Documentation/video4linux/gspca.txt",
> but didn't find such a device.

The 6413 is a UVC compatible camera / controller from Microdia, as
such it should use the uvcvideo driver.

Basically on any modern Linux distribution, it should just work as
soon as you plug it in.

Regards,

Hans
