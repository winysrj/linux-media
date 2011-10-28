Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56310 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1J1Tqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 15:46:54 -0400
Received: by wyg36 with SMTP id 36so4248795wyg.19
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2011 12:46:53 -0700 (PDT)
Message-ID: <4eab06ac.10c5e30a.74de.67a0@mx.google.com>
Subject: Re: Avermedia TV Pilot
From: Malcolm Priestley <tvboxspy@gmail.com>
To: =?UTF-8?Q?Zbyn=C4=9Bk?= Kocur <zbynek.kocur@fel.cvut.cz>
Cc: linux-media@vger.kernel.org
Date: Fri, 28 Oct 2011 20:46:47 +0100
In-Reply-To: <4EAAD20A.6000705@fel.cvut.cz>
References: <4EAAC8AC.70407@fel.cvut.cz> <4EAAD20A.6000705@fel.cvut.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2011-10-28 at 18:02 +0200, Zbyněk Kocur wrote:
> Hi,
> 
> I have new Linux DVB-T card from Avermedia. Avermedia TV Pilot but it is
> not supported in kernel. Is it possible to support this USB TV DVB-T? It
> has a chipset which is currently supported but demodulator is without
> support.
> 
> lsusb
> Bus 002 Device 007: ID 07ca:0810 AVerMedia Technologies, Inc.
> 
> It has a followed chpsets:
> TDA18271    (Supported)
> CX23102        (Supported)
> and
> AF9030        (Not supported :-()
> 

AF903x series are not directly supported by V4L.

it913x-fe driver is loosely based on the AF903x frontend. In its private
header are some af9035 references.

At some point af903x may be spun out of the it913x-fe driver.

However, these devices use one or two controllers in a number of
different interfacing combinations.

Regards

Malcolm

