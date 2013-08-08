Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966648Ab3HHVUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 17:20:53 -0400
Date: Thu, 8 Aug 2013 14:20:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: mario tillmann <mario.t4man@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 'Siano Mobile Silicon' firmware doesn't load in 3.10.x
Message-ID: <20130808212052.GA19938@kroah.com>
References: <CAAyapezWNY64CgPnwq63fFsidYke82X2c3Mk0Uq8KpYi4L8-tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAyapezWNY64CgPnwq63fFsidYke82X2c3Mk0Uq8KpYi4L8-tA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 08, 2013 at 05:52:53PM +0200, mario tillmann wrote:
> With the latest kernel 3.10.x I get an error message when loading the firmware
> sms1xxx-hcw-55xxx-dvbt-02.fw:
> 
> smscore_load_firmware_family2: line: 986: sending
> MSG_SMS_DATA_VALIDITY_REQ expecting 0xcfed1755
> smscore_onresponse: line: 1565: MSG_SMS_DATA_VALIDITY_RES, checksum = 0xcfed1755
> 
> This error is reported for 32/64 bit systems.
> 
> If I can assist in debugging, please let me know.

This is a media driver, I would suggest the linux-media mailing list
would know much more than the usb mailing list does (cc:ed).


