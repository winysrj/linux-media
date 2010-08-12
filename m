Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <matthiaz.weber@gmx.de>) id 1OjaZZ-0002gX-3q
	for linux-dvb@linuxtv.org; Thu, 12 Aug 2010 18:24:05 +0200
Received: from mailout-de.gmx.net ([213.165.64.23] helo=mail.gmx.net)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with smtp
	for <linux-dvb@linuxtv.org>
	id 1OjaZY-0003f3-Bl; Thu, 12 Aug 2010 18:24:04 +0200
Message-ID: <4C642024.5070905@gmx.de>
Date: Thu, 12 Aug 2010 18:24:04 +0200
From: Matthias Weber <matthiaz.weber@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Cc: abraham.manu@gmail.com
Subject: [linux-dvb] libdvbsec - trying to control DiSEqC positioner
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi.

We are trying to use the libdvbsec-api from the dvb-apps package
(/dvb_apps/lib/libdvbsec) to build our own DiSEqC positioner control.
It's going to implement a kind of USALS/GotoX/GotoXX/DiSEqC1.3, whatever
you want to call it (there's no hardware receiver provided atm).

But at the moment there are a few problems with the positioner:


For getting started I took a look at /util/gotox/gotox.c.
In this file the function dvbsec_diseqc_goto_rotator_bearing is used.
This function is for turning to a specific angle. (using 0x6E as command
byte)

For any reason our rotor/motor/positioner only wants to turn to western
degrees (but in the full range of 75=B0W..0=B0).

The positioner: JAEGER Genuine SG-2500A DiSEqC 1.2 H-H MOUNT
I think this seems to be an OEM product as I compared several positioners.
They all have the same instruction manual, pictures, ...

I checked the hardware limits; they were not set. So theoretically the
range of movement is 75=B0W..0=B0..75=B0E.

I also tried to delete theoretical software limits by
- calling the dvbsec_diseqc_disable_satpos_limits command before calling
the dvbsec_diseqc_goto_rotator_bearing command
- tried the same sending the "raw" DiSEqC command message (command byte
0x63)

The positioner can manually be rotated in the complete range of movement
of 75=B0W..0=B0..75=B0E.

As I don't really want to manually control the motor any time and the
dvbsec_diseqc_goto_rotator_bearing function doesn't work for me,
I tried using the dvbsec_diseqc_goto_satpos_preset function. This works
quite well, also for satellite with eastern longitude.
The problem is: when choosing Astra (19.2E) for example, the motor of
course turns to 19.2=B0E. This only works for your own position when you
live at longitude 0=B0.

This is why these motors provide something called
recalculation/resynchronization. You go to the preset satellite position
and correct the difference in longitude by manually turning the
positioner. Afterwards you have to tell the positioner to correct all
the satellite positions. This normally only has to be done once. Here
the lib also offers a command:
dvbsec_diseqc_recalculate_satpos_positions. I tried using it after
calling the dvbsec_diseqc_goto_satpos_preset function. Unfortunately I
am not quite sure which arguments to deliver. I once tried -1, -1 and
then 0x00 0x00 and the the index number of the builtin satellite table
entry. I am not sure how to use it correctly, but all in all it didn't work.

Coming back to the dvbsec_diseqc_goto_rotator_bearing function:
I am not sure if the specifications/ application notes which were made
public are too old (I directly downloaded the files from EUTELSAT[1]),
the implementation in the positioner differs, code in the lib is wrong
or something else doesn't work correctly:

If the angle delivered to the function is negative, the high nibble of
byte 3 (the 4th byte) of the DiSEqC message is set to 0xD, else it's set
to 0xE.
The positioner application note (v1.0) says the high nibble of byte 3 is
0x0, 0x1 or 0xF.

Are there any further documents, implementations,... experience with
positioners?

Any help provided will be great! Thanks!

Cheers,
Matthias


[1] http://www.eutelsat.com/satellites/4_5_5.html
    Bus Specification, Positioner Application Note, etc


PS: Not quite sure if I should use this list or linux-media, but as it
seems this message is also automatically forwarded to this list, isn't it?

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
