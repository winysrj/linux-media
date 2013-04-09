Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58145 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:32:05 -0400
Received: by mail-ia0-f174.google.com with SMTP id b35so6015905iac.5
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 02:32:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK2FuSnprxO78R1u6mSVXJX7WQ0Q_nnr+3vkW7x_y2YuYwHR9Q@mail.gmail.com>
References: <CAK2FuSnQxgc2hvtgb=COH0BGaJVqY5Cg=4fYWpB_BwOn8TYE_w@mail.gmail.com>
 <516193FF.50709@schinagl.nl> <CAK2FuSnprxO78R1u6mSVXJX7WQ0Q_nnr+3vkW7x_y2YuYwHR9Q@mail.gmail.com>
From: =?UTF-8?Q?C=C3=A9dric_Girard?= <girard.cedric@gmail.com>
Date: Tue, 9 Apr 2013 11:31:44 +0200
Message-ID: <CA+rnASt8dyDM7q3BOqfZ+gHiuT_=yMH4pHpwwqtcysK=2-g9_Q@mail.gmail.com>
Subject: Re: No Signal with TerraTec Cinergy T PCIe dual
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 9, 2013 at 10:47 AM, Jan Saris wrote:
>
> What do you meen by: "Remember to set the frontend properly;
> dvb-fe-tool from memory"??
> To set the delevery system to DVB-C before running the dvbv5-scan??


Yes but from what I remember, DVB-C is the default.
Anyway the flag from dvb-fe-tool to use is --set-delsys=DVB-C in your case.


--
Cédric Girard
