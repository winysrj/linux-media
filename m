Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:22939 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZIQE6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 00:58:04 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1387942fge.1
        for <linux-media@vger.kernel.org>; Wed, 16 Sep 2009 21:58:06 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org, gennady@exatel-vs.com
Subject: Re: [linux-dvb] The Tuner stv6110x.c driver problem.
Date: Thu, 17 Sep 2009 07:58:36 +0300
References: <C0EA3D8EE7E94C01A6FF929034F088C1@exatelvs.com>
In-Reply-To: <C0EA3D8EE7E94C01A6FF929034F088C1@exatelvs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909170758.37547.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 сентября 2009 09:28:14 gennady wrote:
> Hi!
>
> My stv6110a tuner doesn't work.
>
> I see that there is problem with the divider calculation.
>
>
>
> The code gets the same value = 3 in any case:
>
>
>
> for (rDiv = 0; rDiv <= 3; rDiv++)
>
>  {
>
>              pCalc = (REFCLOCK_kHz / 100) / R_DIV(rDiv);
>
>
>
>              if ((abs((s32)(pCalc - pVal))) < (abs((s32)(1000 - pVal))))
>
>              {
>
>                         rDivOpt = rDiv;
>
>              }
>
> }
>
>
>
> As result is the wrong divider value.
>
>
>
> Is this driver working?
>
>
>
>
>
> Gennady.
>
>
>
> gennady@exatel-vs.com
Hi,

Why do you not use stv6110 ?
It definitely works.

Igor
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
