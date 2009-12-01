Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33571 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZLAR7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 12:59:53 -0500
Received: by fxm5 with SMTP id 5so5198162fxm.28
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 09:59:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B14195D.6000205@autistici.org>
References: <4B14195D.6000205@autistici.org>
Date: Tue, 1 Dec 2009 21:59:57 +0400
Message-ID: <1a297b360912010959w65a6b7c9i5f78cfe0e9df0b52@mail.gmail.com>
Subject: Re: DIY Satellite Web Radio
From: Manu Abraham <abraham.manu@gmail.com>
To: "OrazioPirataDelloSpazio (Lorenzo)" <ziducaixao@autistici.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 30, 2009 at 11:13 PM, OrazioPirataDelloSpazio (Lorenzo)
<ziducaixao@autistici.org> wrote:
> Hi all,
> I'm not a DVB expert but I'm wondering if this idea is feasible:
> For an "amateur" web radio, for what I know, it is really hard to
> being listened in cars, like people do with commercial satellite radio
> [1] . Basically this is unaffortable for private user and this is
> probably the most relevant factor that penalize web radios againt
> terrestrial one.
>
> My question is: is there any way to use the current, cheap, satellite
> internet connections to stream some data above all the coverage of a geo
> satellite? and make the receiver handy (so without any dishes) ?

FWIW, you wont need a satellite dish (some of them operate in the L
Band), unless you are very much out of the footprint, with a weak
signal. Nevertheless, a parabolic reflector will give you a higher
gain, but again that's not the choice for a receiving aerial in a
moving vehicle. Such use cases use in some cases a flat panel antenna
or an antenna array.

DVB-RCS wouldn't work as it needs to be really pointed to the
satellite, nor any Ku or C band transponders. The lower you are in the
spectrum, the more likely to have a better reception with a lower gain
reflector.


http://en.wikipedia.org/wiki/1worldspace
http://www.worldspace.com/howitworks/receivers/AGFwssr.html
http://www.worldspace.com/coveragemaps/antennaguide.html
http://www.satdirectory.com/--worldspace.html

Regards,
Manu
