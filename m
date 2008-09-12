Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 12 Sep 2008 11:17:26 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48CA0355.6080903@linuxtv.org>
Message-ID: <alpine.LRH.1.10.0809121112350.29931@pub3.ifh.de>
References: <48CA0355.6080903@linuxtv.org>
MIME-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
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

Hi Steve,

On Fri, 12 Sep 2008, Steven Toth wrote:
> Patrick, I haven't looked at your 1.7MHz bandwidth suggestion - I'm open
> to ideas on how you think we should do this. Take a look at todays
> linux/dvb/frontend.h and see if these updates help, or whether you need
> more changes.

I attached a patch which adds a DTV_BANDWIDTH_HZ command. That's all. I 
would like to have the option to pass any bandwidth I want to the 
frontend.

Also this patch includes some more things and questions around ISDB-T and 
ISDB-Tsb:

--- frontend.h.old	2008-09-12 10:46:25.351332000 +0200
+++ frontend.h	2008-09-12 11:12:00.326085000 +0200
@@ -258,6 +258,12 @@
  	DTV_FREQUENCY,
  	DTV_MODULATION,
  	DTV_BANDWIDTH,
+
+	/* XXX PB: I would like to have field which describes the
+	 * bandwidth of a channel in Hz or kHz - maybe we can remove the
+	 * DTV_BANDWIDTH now and put a compat layer */
+	DTV_BANDWIDTH_HZ,
+
  	DTV_INVERSION,
  	DTV_DISEQC_MASTER,
  	DTV_SYMBOL_RATE,
@@ -276,18 +282,32 @@
  	/* New commands are always appended */
  	DTV_DELIVERY_SYSTEM,

+	/* XXX PB: is DTV_ISDB the good prefix for ISDB-T parameters ? XXX */
+
  	/* ISDB-T */
-	DTV_ISDB_SEGMENT_IDX,
-	DTV_ISDB_SEGMENT_WIDTH,
+	DTV_ISDB_SEGMENT_IDX, /* maybe a duplicate of DTV_ISDB_SOUND_BROADCASTING_SUBCHANNEL_ID ??? to be checked */
+	DTV_ISDB_SEGMENT_WIDTH, /* 1, 3 or 13 ??? */
+
+	DTV_ISDB_PARTIAL_RECEPTION, /* the central segment can be received independently or 1/3 seg in SB-mode */
+	DTV_ISDB_SOUND_BROADCASTING, /* sound broadcasting is used 0 = 13segment, 1 = 1 or 3 see DTV_ISDB_PARTIAL_RECEPTION */
+
+	/* only used in SB */
+	DTV_ISDB_SOUND_BROADCASTING_SUBCHANNEL_ID, /* determines the initial PRBS of the segment (to match with 13seg channel) */
+
  	DTV_ISDB_LAYERA_FEC,
  	DTV_ISDB_LAYERA_MODULATION,
  	DTV_ISDB_LAYERA_SEGMENT_WIDTH,
+	DTV_ISDB_LAYERA_TIME_INTERLEAVER,
+
  	DTV_ISDB_LAYERB_FEC,
  	DTV_ISDB_LAYERB_MODULATION,
  	DTV_ISDB_LAYERB_SEGMENT_WIDTH,
+	DTV_ISDB_LAYERB_TIME_INTERLEAVING,
+
  	DTV_ISDB_LAYERC_FEC,
  	DTV_ISDB_LAYERC_MODULATION,
  	DTV_ISDB_LAYERC_SEGMENT_WIDTH,
+	DTV_ISDB_LAYERC_TIME_INTERLEAVING,

  } dtv_cmd_types_t;


Sorry for not integrating this into the frontend_cache yet. But I'm really 
out of time (at work and even at home, working on cx24120) and I will not 
be able to supply the DiBcom ISDB-T demod-driver (which would use all 
that) right now.

thanks for all your efforts,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
