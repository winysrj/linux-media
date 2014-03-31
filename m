Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42461 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaCaVMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 17:12:49 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so8785626pab.12
        for <linux-media@vger.kernel.org>; Mon, 31 Mar 2014 14:12:48 -0700 (PDT)
Received: from [10.1.13.41] (limelabs.static.monkeybrains.net. [199.83.221.58])
        by mx.google.com with ESMTPSA id wp3sm45356803pbc.67.2014.03.31.14.12.47
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 31 Mar 2014 14:12:48 -0700 (PDT)
From: Sriakhil Gogineni <sriakhil.gogineni@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Writing a HDMI-CEC device driver for the IT66121 
Message-Id: <4E127074-D400-4334-874D-7A67CF2D42EB@gmail.com>
Date: Mon, 31 Mar 2014 14:12:47 -0700
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to write a HDMI-CEC driver for the Radxa Rock (Specification - Radxa). I am coming from a software background and have found libcec and am looking at other implementation.

I'm wondering how to connect the hardware and software pieces under Linux / Android.

I'm not sure if I need to find out what /dev/ its exposed under via the device tree or determine which register is used from the data sheet?

Any advice / tips / pointers would be helpful.

Best,
Sri