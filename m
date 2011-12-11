Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34121 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1LKM5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 07:57:51 -0500
From: =?utf-8?Q?S=C3=A9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: <joolzg@btinternet.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
Cc: <dubost@crans.org>
References: <20111206230529.45D7D85BD@rouge.crans.org>
In-Reply-To: <20111206230529.45D7D85BD@rouge.crans.org>
Subject: RE: Tr. : Irdeto Cam Problem, any help
Date: Sun, 11 Dec 2011 13:57:46 +0100
Message-ID: <006b01ccb804$7b9bcd90$72d368b0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"en50221_stdcam_llci_poll: Error reported by stack:-7" :
This isn’t really an error, it’s a design flaw in the libdvben50221 (it’s receving something it isn’t waiting for), it’s more a warning.I’ve published a patch for correcting that  few months ago (I think the patch wasn’t noticed...)

There must be something wrong elsewhere, as I never got this error "EN50221ERR_BADCAMDATA".
There is only one place where the code generate this error, in "en50221_stdcam_llci.c", during CAM reset :

static void llci_cam_in_reset(struct en50221_stdcam_llci *llci)
{
	if (dvbca_get_cam_state(llci->cafd, llci->slotnum) != DVBCA_CAMSTATE_READY) {
		return;
	}

	// register the slot
	if ((llci->tl_slot_id = en50221_tl_register_slot(llci->tl, llci->cafd, llci->slotnum,
	      						 LLCI_RESPONSE_TIMEOUT_MS, LLCI_POLL_DELAY_MS)) < 0) {
		llci->state = EN50221_STDCAM_CAM_BAD;
		return;
	}

	// create a new connection on the slot
	if (en50221_tl_new_tc(llci->tl, llci->tl_slot_id) < 0) {
		llci->state = EN50221_STDCAM_CAM_BAD;
		llci->tl_slot_id = -1;
		en50221_tl_destroy_slot(llci->tl, llci->tl_slot_id);
		return;
	}

	llci->state = EN50221_STDCAM_CAM_OK;
}

As there are many possible sources for this error, it may be useful to check the value of the "tl->error" variable.

Sebastien.


From: dubost@crans.org [mailto:dubost@crans.org] 
Sent: mercredi 7 décembre 2011 00:05
To: sraillard@coexsi.fr
Subject: Tr. : Irdeto Cam Problem, any help

C'est pour toi ça. 

-- 
Brice

----- Forwarded message -----
De : "JULIAN GARDNER" <joolzg@btinternet.com>
Pour : "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Objet : Irdeto Cam Problem, any help
Date : mar., déc. 6, 2011 23:50


Been trying now to get my IrdetoCam and card working, im using mumudvb for this.

Turning on debug i get the folowing in the output

nfo:  Autoconf:  Channel number :   0, name : "ERT World"  service id 0 
Info:  Autoconf:      Multicast4 ip : 227.25.0.1:1234
Deb0:  Autoconf:          pids : 5001 (PMT), 1160 (Video (MPEG4-AVC)), 1120 (Audio (MPEG2)), 
Info:  Main:  Channel "ERT World" is
now higly scrambled (97% of scrambled packets). Card 0
en50221_tl_handle_sb: Received T_SB for connection not in T_STATE_ACTIVE from module on slot 00

en50221_stdcam_llci_poll: Error reported by stack:-7

Deb1:  CAM:  Status change from EN50221_STDCAM_CAM_INRESET to EN50221_STDCAM_CAM_OK.
WARN: 
CAM:  Transport Layer Error change from EN50221ERR_NONE (No Error.) to 
EN50221ERR_BADCAMDATA (CAM supplied an invalid request.)
Deb1:  CAM:  CAM Application_Info_Callback
Info:  CAM:  CAM Application type: 01
Info:  CAM:  CAM Application manufacturer: cafe
Info:  CAM:  CAM Manufacturer code: babe
Info:  CAM:  CAM Menu string: Irdeto Access

Now can anybody help with the -7 error, as i am getting no decryption.

Patches would be welcome, before i start trying to delve deeper in

joolz
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

