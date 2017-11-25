Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54710 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdKYLyl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 06:54:41 -0500
Date: Sat, 25 Nov 2017 09:54:35 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dvbv5-scan: Missing NID, TID, and RID in VDR channel output
Message-ID: <20171125095435.75c982f4@vento.lan>
In-Reply-To: <20171125090819.1a55e11a@vento.lan>
References: <f65773a8-603a-ba10-b420-896efc70c26a@googlemail.com>
        <20171125090819.1a55e11a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Nov 2017 09:08:19 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hi Gregor,
> 
> Em Wed, 22 Nov 2017 20:50:56 +0100
> Gregor Jasny <gjasny@googlemail.com> escreveu:
> 
> > Hello Mauro and list,
> > 
> > since some days my region in Germany finally got DVB-T2 coverage.
> > Something in the broadcasted tabled makes w_scan only find a subset each
> > time. dvbv5-scan is somewhat more reliable.  But with the VDR compatible
> > channel list exported from dvbv5-scan I cannot make VDR produce any EPG.  
> > >From skimming over the VDR code I think this is due to missing NID and TID.  
> > 
> > The upper one is from dvbv5-scan, the lower one from w_scan:
> >   
> > >                                                                       VPID    APID                   TPID  CA SID  NID   TID    RID
> > > arte HD    :618000:B8 C999 D999 G19128 I999 M999 S1 T16 Y0   :T:27500 :210    :220,221               :0    :0 :770 :0    :0     :0
> > > arte HD;ARD:618000:B8      D0   G19256           S1 T32 Y0 P0:T:27500 :210=36 :220=deu@17,221=fra    :230  :0 :770 :8468 :15106 :0  
> > 
> > Mauro, do you think it would be possible to parse / output NID, TID, and
> > RID from dvbv5_scan? It would greatly improve usability.  
> 
> It is possible. Not sure how much efforts it would take. Could you please
> send me, in priv, a capture of ~30-60 seconds of a recent DVB-T2 channel
> in Germany with those fields, and the corresponding output from w_scan,
> for all channels at the same frequency?
> 
> I'll use it to test it with my RF generator here, and see if I can tweak
> dvbv5-scan to produce the same output.
> 
> The syntax to capture the full MPEG-TS is:
> 
> 	$ dvbv5-zap -P -o channel.ts -t 60 scan_file.conf
> 
> 
> Even 60seconds produce a big file, so you'll likely need to store 
> somewhere (like Google Drive) and send me a link to it.
> 

Btw, it follows a quick hack that should output network and transport ID.

Please test. It should be noticed that it adds two new fields on a struct
that it is part of the API. I didn't care to check if this patch would break
userspace API.

I'm not sure what field is "RID". From w_scan's dump-vdr.c:

        fprintf (f, ":%d:%d:%d:0",
                s->service_id,
                (t->transport_stream_id > 0)?t->original_network_id:0,
                t->transport_stream_id);

        if (flags->print_pmt) {
                fprintf (f, ":%d", s->pmt_pid);
                }

It seems that it is the pmt_pid. If so, it shoudn't be hard to add it as
well.


-- 
Thanks,
Mauro

[RFC] Add support for network and transport ID

The network and transport ID are expected by VDR. Add support for them.

PS.: compile-tested only.

Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/lib/include/libdvbv5/dvb-file.h b/lib/include/libdvbv5/dvb-file.h
index 5b12c8f4d272..1147038d8e69 100644
--- a/lib/include/libdvbv5/dvb-file.h
+++ b/lib/include/libdvbv5/dvb-file.h
@@ -118,6 +118,11 @@ struct dvb_entry {
 	unsigned freq_bpf;
 	unsigned diseqc_wait;
 	char *lnb;
+
+	/* FIXME: should fix soname on those */
+	uint16_t network_id;
+	uint16_t transport_id;
+
 };
 
 /**
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 0664435a36ef..ffdfe292d6d9 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -609,6 +609,16 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 		return 0;
 	}
 
+	if (!strcasecmp(key, "NETWORK_ID")) {
+		entry->network_id = atol(value);
+		return 0;
+	}
+
+	if (!strcasecmp(key, "TRANSPORT_ID")) {
+		entry->transport_id = atol(value);
+		return 0;
+	}
+
 	if (!strcasecmp(key, "VCHANNEL")) {
 		entry->vchannel = strdup(value);
 		return 0;
@@ -863,6 +873,12 @@ int dvb_write_file(const char *fname, struct dvb_file *dvb_file)
 		if (entry->service_id)
 			fprintf(fp, "\tSERVICE_ID = %d\n", entry->service_id);
 
+		if (entry->network_id)
+			fprintf(fp, "\tNETWORK_ID = %d\n", entry->network_id);
+
+		if (entry->transport_id)
+			fprintf(fp, "\tTRANSPORT_ID = %d\n", entry->transport_id);
+
 		if (entry->video_pid_len){
 			fprintf(fp, "\tVIDEO_PID =");
 			for (i = 0; i < entry->video_pid_len; i++)
@@ -1108,6 +1124,8 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 				 struct dvb_file *dvb_file,
 				 struct dvb_v5_descriptors *dvb_scan_handler,
 				 const uint16_t service_id,
+				 const uint16_t network_id,
+				 const uint16_t transport_id,
 				 char *channel,
 				 char *vchannel,
 				 int get_detected, int get_nit)
@@ -1162,6 +1180,8 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 
 	/* Initialize data */
 	entry->service_id = service_id;
+	entry->network_id = network_id;
+	entry->transport_id = transport_id;
 	entry->vchannel = vchannel;
 	entry->sat_number = parms->p.sat_number;
 	entry->freq_bpf = parms->p.freq_bpf;
@@ -1281,7 +1301,7 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 					vchannel, channel);
 
 			rc = get_program_and_store(parms, *dvb_file, dvb_scan_handler,
-						d->program_number,
+						d->program_number, 0, 0,
 						channel, vchannel,
 						get_detected, get_nit);
 			if (rc < 0)
@@ -1294,6 +1314,7 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 	dvb_sdt_service_foreach(service, dvb_scan_handler->sdt) {
 		char *channel = NULL;
 		char *vchannel = NULL;
+		uint16_t network_id = 0, transport_id = 0;
 		int r;
 
 		dvb_desc_find(struct dvb_desc_service, desc, service, service_descriptor) {
@@ -1321,8 +1342,15 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 			dvb_log(_("Storing as channel %s"), channel);
 		vchannel = dvb_vchannel(parms, dvb_scan_handler->nit, service->service_id);
 
+		if (dvb_scan_handler->nit->transport) {
+			network_id = dvb_scan_handler->nit->transport->network_id;
+			transport_id = dvb_scan_handler->nit->transport->transport_id;
+		}
+
 		rc = get_program_and_store(parms, *dvb_file, dvb_scan_handler,
 					   service->service_id,
+					   network_id,
+					   transport_id,
 					   channel, vchannel,
 					   get_detected, get_nit);
 		if (rc < 0)
@@ -1361,7 +1389,8 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 			}
 
 			rc = get_program_and_store(parms, *dvb_file, dvb_scan_handler,
-						   service_id, NULL, NULL,
+						   service_id, 0, 0,
+						   NULL, NULL,
 						   get_detected, get_nit);
 			if (rc < 0)
 				return rc;
diff --git a/lib/libdvbv5/dvb-vdr-format.c b/lib/libdvbv5/dvb-vdr-format.c
index 3d09237afe2a..d2365712c9a9 100644
--- a/lib/libdvbv5/dvb-vdr-format.c
+++ b/lib/libdvbv5/dvb-vdr-format.c
@@ -422,10 +422,10 @@ int dvb_write_format_vdr(const char *fname,
 		fprintf(fp, "%d:", entry->service_id);
 
 		/* Output Network ID */
-		fprintf(fp, "0:");
+		fprintf(fp, "%d:", entry->network_id);
 
 		/* Output Transport Stream ID */
-		fprintf(fp, "0:");
+		fprintf(fp, "%d:", entry->transport_id);
 
 		/* Output Radio ID
 		 * this is the last entry, tagged bei a new line (not a colon!)
