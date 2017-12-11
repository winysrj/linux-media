Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34669 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbdLKPpI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 10:45:08 -0500
Date: Mon, 11 Dec 2017 13:45:01 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 5/6] [media] cxusb: implement Medion MD95700 digital
 / analog coexistence
Message-ID: <20171211134501.4a7270ec@vento.lan>
In-Reply-To: <f80a8f9e-f142-086e-9160-aea829eac9dc@maciej.szmigiero.name>
References: <f80a8f9e-f142-086e-9160-aea829eac9dc@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 23:36:55 +0200
"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> escreveu:

> This patch prepares cxusb driver for supporting the analog part of
> Medion 95700 (previously only the digital - DVB - mode was supported).
> 
> Specifically, it adds support for:
> * switching the device between analog and digital modes of operation,
> * enforcing that only one mode is active at the same time due to hardware
> limitations.
> 
> Actual implementation of the analog mode will be provided by the next
> commit.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

This patch doesn't apply:

Hunk #2 FAILED at 25.
Hunk #3 FAILED at 47.
Hunk #4 succeeded at 90 (offset 1 line).
Hunk #5 succeeded at 102 (offset 1 line).
Hunk #6 succeeded at 262 (offset 1 line).
Hunk #7 succeeded at 270 (offset 1 line).
Hunk #8 succeeded at 389 (offset 2 lines).
Hunk #9 succeeded at 683 (offset 2 lines).
Hunk #10 succeeded at 799 (offset 2 lines).
Hunk #11 succeeded at 1533 (offset 2 lines).
Hunk #12 succeeded at 1644 (offset 2 lines).
Hunk #13 succeeded at 1770 (offset 2 lines).
Hunk #14 succeeded at 1783 (offset 2 lines).
Hunk #15 succeeded at 1803 (offset 2 lines).
Hunk #16 succeeded at 1879 (offset 2 lines).
Hunk #17 succeeded at 2649 (offset 2 lines).
2 out of 17 hunks FAILED
checking file drivers/media/usb/dvb-usb/cxusb.h
Hunk #1 succeeded at 2 (offset 1 line).
Hunk #2 succeeded at 37 (offset 1 line).
Hunk #3 succeeded at 49 (offset 1 line).
checking file drivers/media/usb/dvb-usb/dvb-usb-dvb.c
Hunk #1 succeeded at 15 (offset 1 line).
Hunk #2 succeeded at 25 (offset 1 line).
Hunk #3 succeeded at 43 (offset 1 line).
Hunk #4 succeeded at 64 (offset 1 line).
Hunk #5 succeeded at 90 (offset 1 line).
checking file drivers/media/usb/dvb-usb/dvb-usb-init.c
checking file drivers/media/usb/dvb-usb/dvb-usb.h
Hunk #1 succeeded at 143 (offset 1 line).
Hunk #2 succeeded at 235 (offset 1 line).
Hunk #3 succeeded at 281 (offset 1 line).
 drivers/media/usb/dvb-usb/cxusb.c        |  450 +++++++++++++++++++++++++++----
 drivers/media/usb/dvb-usb/cxusb.h        |   48 +++
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c  |   20 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   13 
 drivers/media/usb/dvb-usb/dvb-usb.h      |    8 
 5 files changed, 486 insertions(+), 53 deletions(-)
