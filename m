Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n21.bullet.mail.ukl.yahoo.com ([87.248.110.138])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K3zhh-0006bQ-JE
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 22:35:30 +0200
Date: Wed, 04 Jun 2008 16:19:38 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1212610778l.7239l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] No lock on a particular transponder with TT S2-3200
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

	Hi all,
one more datapoint for the TT 3200 tuning problems. I solved all my =

locking problems by add 4MHz to the reported frequencies (coming from =

the stream tables); note that one of the transponders always locked =

even without this correction (its freq is 11093MHz, the others are : =

11555, 11635, 11675MHz), so as you see the others are much higher.
Now there is another transponder at 11495MHz but this one I cant lock =

on it even with my correction. Here are its characteristic as reported =

by dvbsnoop when tuned to another transponder by szap:
    Transport_stream_ID: 605 (0x025d)
    Original_network_ID: 1 (0x0001)  [=3D Astra Satellite Network 19,2=B0E =

| Soci=E9t=E9 Europ=E9enne des Satellites]
    reserved_1: 15 (0x0f)
    Transport_descriptor_length: 13 (0x000d)

            DVB-DescriptorTag: 67 (0x43)  [=3D =

satellite_delivery_system_descriptor]
            descriptor_length: 11 (0x0b)
              0000:  43 0b 01 14 95 00 32 55  a1 03 00 00 04            =

C.....2U.....
            Frequency: 18126080 (=3D  11.49500 GHz)
            Orbital_position: 12885 (=3D 325.5)
            West_East_flag: 1 (0x01)  [=3D EAST]
            Polarisation: 1 (0x01)  [=3D linear - vertical]
            Kind: 0 (0x00)  [=3D DVB-S]
            fixed ('00'): 0 (0x00)
            Modulation_type: 1 (0x01)  [=3D QPSK]
            Symbol_rate: 3145728 (=3D  30.0000)
            FEC_inner: 4 (0x04)  [=3D 5/6 conv. code rate]

The difference between this one and the 4 other transponders I can lock =

on is that this one has a different FEC (5/6) and the channels on it =

are HD, but it is still DVB-S.
I know it works with my STB, so something is wrong here.
I would like to hack on szap or scan to be able to try several freq on =

a row and get the logs from it. I will post the result ASAP.
IIRC szapping to the bad channel I get no lock but in the dmesg lock it =

seems to get the carrier, weird...
I hope someone can make some sense out of that.
Oh and I am using multiproto as of just before the API change that =

broke mythtv compat but I backported some fixes.
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
