Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:60874 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZCUBkh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 21:40:37 -0400
Date: Sat, 21 Mar 2009 02:40:17 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Simon Peter <klik.atekon.de@googlemail.com>
Subject: Re: HD PVR question
Message-ID: <20090321014017.GE5383@aniel>
References: <85d71c370903201823v55eebc9ar89bf8b3213b72e82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85d71c370903201823v55eebc9ar89bf8b3213b72e82@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

answering to linux-media@vger.kernel.org since such things should be
asked and archieved on a mailing list.

On Sat, Mar 21, 2009 at 02:23:33AM +0100, Simon Peter wrote:
> 
> is there a way to set the resolution to 720x576 in the Linux driver
> when capturing S-Video?

If you feed a pal signal into the S-Video input the resolution should be
720 or 704 to 576. You have to select the s-video input and set the
standard to pal variant with 50Hz. But if you don't do that you won't
get any data.

There is to my knowledge no scaler in the device.

Janne
