Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1005.centrum.cz ([90.183.38.135])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hoppik@centrum.cz>) id 1Kao85-0003Hi-An
	for linux-dvb@linuxtv.org; Wed, 03 Sep 2008 10:54:23 +0200
Received: by mail1005.centrum.cz id S738267175AbYICIyH (ORCPT
	<rfc822;linux-dvb@linuxtv.org>); Wed, 3 Sep 2008 10:54:07 +0200
Date: Wed, 03 Sep 2008 10:54:07 +0200
From: " =?UTF-8?Q?SKO=C4=8CDOPOLE?= =?UTF-8?Q?=20Tom=C3=A1=C5=A1?="
	<hoppik@centrum.cz>
To: <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <200809031054.6772@centrum.cz>
Subject: [linux-dvb] Measuring signal strench on TT S2-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

For quick test I used getstream utility. Later I am planning to use vdr with some plugins for streaming. 

I have parabola directed to 23.5E (Astra 3A/1E). I tested two FTA programs Ocko and CT24. On second computer there was VLC running. I think parabola is directed correctly, because I have borrowed desktop receiver and there was no problem with these programs.

I tried latest drivers from Igor M. Liplianin but I have the same problems with multiproto drivers.

When I was streaming Ocko, on second computer there was good screen, but sometimes (aprox once per 30 seconds) was shortly breaking.

When I was streaming CT24, it was running only for max 10 seconds and then getstream utility stopped sending stream packets.

There is debug output from getstream utility:
2008-08-31 20:11:59.655 fe: Adapter 0 Setting up frontend tuner
2008-08-31 20:11:59.668 fe: DVB-S tone = 0
2008-08-31 20:11:59.668 fe: DVB-S voltage = 0
2008-08-31 20:11:59.668 fe: DVB-S diseqc = 0
2008-08-31 20:11:59.668 fe: DVB-S freq = 12525000
2008-08-31 20:11:59.668 fe: DVB-S lof1 = 9750000
2008-08-31 20:11:59.668 fe: DVB-S lof2 = 10600000
2008-08-31 20:11:59.668 fe: DVB-S slof = 11700000
2008-08-31 20:11:59.668 fe: DVB-S feparams.frequency = 1925000
2008-08-31 20:11:59.668 fe: DVB-S feparams.inversion = 2
2008-08-31 20:11:59.668 fe: DVB-S feparams.u.qpsk.symbol_rate = 27500000
2008-08-31 20:11:59.668 dmx: Setting filter for pid 8192 pestype 20
2008-08-31 20:11:59.816 fe: Adapter 0 Status: 0x1e (HAS_CARRIER HAS_VITERBI HAS_SYNC HAS_LOCK)

And there is configuration file:
# cat /usr/src/getstream/getstream.conf.cslink
http {
    port 8001;
};

adapter 0 {
  budget-mode 1;

    dvb-s {
        lnb {
            lof1 9750000;
            lof2 10600000;
            slof 11700000;
        };

        transponder {
            frequency 12525000;
            polarisation v;
            symbol-rate 27500000;
            diseqc 0;
        };
    };

    stream {
        name "CT24";
        input {
            pnr 8006;
        };
        output-rtp {
            remote-address 10.0.148.98;
            remote-port 3000;
        };
        sap {
                scope global;
                playgroup "testovaci sat";
                ttl 5;
        };
    };
};


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
