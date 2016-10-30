Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:39154 "EHLO mail.southpole.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751594AbcJ3NMk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Oct 2016 09:12:40 -0400
Received: from [192.168.1.138] (assp.southpole.se [37.247.8.10])
        by mail.southpole.se (Postfix) with ESMTPSA id 77F814404EC
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2016 14:12:36 +0100 (CET)
Subject: Re: [BUG] non working drivers with current linuxtv git on Ubuntu
 16.04.1 LTS
To: linux-media@vger.kernel.org
References: <bdd2742f-3249-9a9b-9703-be0be33bb556@southpole.se>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <568d75cc-4c1c-3547-00e1-4e1bd0464afc@southpole.se>
Date: Sun, 30 Oct 2016 14:12:36 +0100
MIME-Version: 1.0
In-Reply-To: <bdd2742f-3249-9a9b-9703-be0be33bb556@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/2016 01:22 PM, Benjamin Larsson wrote:

> I got this for my anysee card:
>
> dvb_usb_anysee: disagrees about version of symbol dvb_ca_en50221_init
> dvb_usb_anysee: Unknown symbol dvb_ca_en50221_init (err -22)
> dvb_usb_anysee: disagrees about version of symbol dvb_ca_en50221_release
> dvb_usb_anysee: Unknown symbol dvb_ca_en50221_release (err -22)
> dvb_usb_anysee: disagrees about version of symbol rc_keydown
> dvb_usb_anysee: Unknown symbol rc_keydown (err -22)
> dvb_usb_anysee: disagrees about version of symbol
> dvb_usbv2_generic_rw_locked
> dvb_usb_anysee: Unknown symbol dvb_usbv2_generic_rw_locked (err -22)
>

For unknown reasons the anysee module was not enabled.

MvH
Benjamin Larsson

