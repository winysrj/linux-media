Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:47195 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab0E1R3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 13:29:23 -0400
Date: Fri, 28 May 2010 19:30:28 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] Remove obsolete zc0301 v4l driver
Message-ID: <20100528193028.1f83c502@tele>
In-Reply-To: <20100528170729.5164.67807.sendpatchset@localhost.localdomain>
References: <20100528170611.5164.29857.sendpatchset@localhost.localdomain>
	<20100528170729.5164.67807.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 May 2010 13:03:28 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> Subject: [PATCH 6/6] Remove obsolete zc0301 v4l driver
> 
> Duplicate functionality with the gspca_zc3xx driver, zc0301 only
> supports 2 USB-ID's (because it only supports a limited set of
> sensors) wich are also supported by the gspca_zc3xx driver
> (which supports 53 USB-ID's in total).

You forgot to remove the conditionnal compilation in the gspca_zc3xx
driver (USB_DEVICE(0x046d, 0x08ae) in gspca/zc3xx.c)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
