Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KhnSD-0006F5-IN
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 17:36:02 +0200
Received: by ey-out-2122.google.com with SMTP id 25so415088eya.17
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 08:35:58 -0700 (PDT)
Date: Mon, 22 Sep 2008 17:35:49 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: =?ISO-8859-15?Q?Javier_G=E1lvez_Guerrero?=
	<javier.galvez.guerrero@gmail.com>
In-Reply-To: <145d4e1a0809220101j4063c300s7ec63ab13362bdf9@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809221717510.13969@ybpnyubfg.ybpnyqbznva>
References: <145d4e1a0809220101j4063c300s7ec63ab13362bdf9@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-H support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, 22 Sep 2008, Javier G=E1lvez Guerrero wrote:

> Has anyone succeed in receiving a DVB-H stream with dvb-utils? If so, whi=
ch
> hardware have you used?

Thanks for the kick in the pants that I needed...

Disclaimer:  I write this with *no* knowledge of the details
of DVB-H...

I have a portable DVB-T receiver which has received as a
Radio service the Bayerisches Fernsehen DVB-H test as part
of a DVB-T multiplex.  And I just positioned an antenna to
tune in a dedicated DVB-H multiplex and received several
of the services therein as Radio services (naturally,
nothing is to be heard).

Thinking that I should be able to use any DVB-T capable
hardware to get something, I did in fact use `scan' to
tune in a handful of services -- after applying a patch
which I've forgotten, to enable my dvb_usb_cxusb device...


I'm going to have to use `dvbsnoop' to study the makeup of
the various PIDs within, as a generic `scan' reveals the
presence of the services but nothing more.


In the case of the Siano sms1xxx hardware, there are two
different DVB firmwares supplied for the device I have, as
well as several different modes.  The default is DVB-T (BDA), =

which the present linux-dvb source supports, but at present,
there is no support for using the other modes.

I have no idea how the firmware differs, or what needs to
be added to the existing siano source in linux-dvb to use
the dvbh firmware -- perhaps it at least utilizes the time-
slicing to operate the hardware more power-efficiently than
the DVB-T firmware...

Anyway, so far none of the dvb-utils have native support that
I know of for DVB-H, as the present API does not support it
directly.



Ha.  Now I've got something to keep me busy for a while and keep
me from bothering this mailing list

thanks
barry bouwsma
oktoberfest via dvb-h?  prosit!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
