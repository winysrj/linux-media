Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:49375 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZB1LyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 06:54:24 -0500
Message-ID: <49A925EC.5050202@kaiser-linux.li>
Date: Sat, 28 Feb 2009 12:54:20 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Anders Blomdell <anders.blomdell@control.lth.se>
CC: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: Topro 6800 driver
References: <49A8661A.4090907@control.lth.se>
In-Reply-To: <49A8661A.4090907@control.lth.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anders

Anders Blomdell wrote:
> Anybody who has a good idea of how to find a DQT/Huffman table that works with
> this image data?

You can search in the Windoz binary driver for JPEG markers (FFxx). 
Maybe, you can find a basic DQT/Huffman table in there.

Regards, Thomas

