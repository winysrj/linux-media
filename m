Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JWHzO-0008TF-SP
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 22:14:27 +0100
Received: by ug-out-1314.google.com with SMTP id o29so2757726ugd.20
	for <linux-dvb@linuxtv.org>; Mon, 03 Mar 2008 13:13:52 -0800 (PST)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Mon, 3 Mar 2008 22:13:35 +0100
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
In-Reply-To: <20080303132157.GA9749@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803032213.35430.christophpfister@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Montag 03 M=E4rz 2008 schrieb Florian Lohoff:
<snip>
> I have no problem with beeing able to query stats - I have a problem
> that a GET call changes in kernel state, and the SET calls options get
> ignored where it should be the other way round.
>
> Probably you can tell me the reason the delivery option in the
> dvbfe_params gets ignored on a DVBFE_SET_PARAMS ? I dont see the
> rational behind this... The option is there - correctly filled and
> gets ignored or better overriden by previous ioctls - Every other
> parameter for the delivery mode is in that struct.
>
> Please tell me why the GET_INFO delsys/delivery option gets set as the ne=
xt
> to use delivery mode. Even if i want to have stats just dont fill them
> when the delsys does not match the currently set delsys as that would
> be the right thing - Querying DVB-S2 stats when tuned to DVB-S should
> return nothing as there are no stats - but setting the delsys to DVB-S
> is BROKEN as i asked for stats not to change the delsys.
>
> > Additionally, this was quite discussed in a long discussion a while
> > back. You might like to read through those as well.
>
> I did partially of it ... and i found the same corners of this API to be
> broken by design.
>
> > Maybe DVBFE_GET_INFO can probably be renamed to DVBFE_INFO if it really
> > itches so much.
>
> No - its much more fundamental problem ... Options belonging
> together are passed in seperate ioctls in non obvious (read: strange)
> ways into the kernel (delivery system via GET_INFO and delivery options
> via SET_PARAMS).
>
> Options which are together in the same struct are not used together e.g.
> delivery mode and parameters are in the same struct which get passed by
> an ioctl but get partially ignored or better overridden by previous
> ioctls in non obvious ways...
>
> As i said - incoherent mess from the user api ...

+1

> Flo

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
