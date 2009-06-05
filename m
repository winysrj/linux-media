Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:58630 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZFEP7p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 11:59:45 -0400
Date: Fri, 5 Jun 2009 17:59:16 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Gonsolo <gonsolo@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Can't find firmware when resuming
In-Reply-To: <4A2844E0.1010902@gmail.com>
Message-ID: <alpine.LRH.1.10.0906050925280.23189@pub2.ifh.de>
References: <4A2844E0.1010902@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gonsolo,

I'm adding the LMML.

On Fri, 5 Jun 2009, Gonsolo wrote:

> Hello!
>
> Is the following problem known?
> The Hauppauge Nova-T stick hangs the resume for 60 seconds.
> The firmware is there and I can watch TV before suspending.
>
> From my dmesg:
>
> [34258.180072] usb 1-1: reset high speed USB device using ehci_hcd and 
> address 4
> [34258.312799] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state, will 
> try to load a firmware
> [34258.312805] usb 1-1: firmware: requesting dvb-usb-dib0700-1.20.fw
> [34318.312097] dvb-usb: did not find the firmware file. 
> (dvb-usb-dib0700-1.20.fw) Please see linux/Documentation/dvb/ for mor
> e details on firmware-problems. (-2)

You are resuming from suspend2disk, right?

The driver is using a standard method to retrieve the firmware buffer from 
user-space, if it does not work, it is a problem of you installation, 
namely udev.

OTOH, the dvb-usb-framework is not ready to handle a suspend2disk 
correctly. E.g. being able to suspend2disk while watching TV will work, 
but when resuming it will be seen as a device disconnect and the 
application will stop to work.


Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
