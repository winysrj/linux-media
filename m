Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60936 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab1DDUlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 16:41:47 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
Cc: <mchehab@redhat.com>, <manu@linuxtv.org>
References: <008f01cbd9c3$55b81a90$01284fb0$@coexsi.fr>
In-Reply-To: <008f01cbd9c3$55b81a90$01284fb0$@coexsi.fr>
Subject: RE: [PATCH] DVB-APPS : correct some issues in libdvben50221
Date: Mon, 4 Apr 2011 22:41:44 +0200
Message-ID: <00e301cbf308$b6f52c40$24df84c0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Mauro and Manu,

As maintainers of the dvb-apps tree, did you have some chance to look at the
patches I've sent to correct some issues with the libdvben50221?
I think it can help to solve some issues, especially when using the CAM menu
(MMI).
Please feel free to discuss any point that seems blocking for including this
patch!

Best regards,
Sebastien


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sébastien RAILLARD (COEXSI)
> Sent: jeudi 3 mars 2011 17:52
> To: Linux Media Mailing List
> Subject: [PATCH] DVB-APPS : correct some issues in libdvben50221
> 
> Dear all,
> 
> Here are two patches against the latest version of libdvben50221 in the
> hg repository.
> 
> Details of corrections:
> -----------------------
> 
> * In "en50221_sl_handle_close_session_response", the expected data
> length wasn't good, the "close_session_response" object is 3 bytes long,
> not 4 bytes long (see the specification)
> 
> * The "LLCI_RESPONSE_TIMEOUT_MS" has been increased from 1000ms to
> 10000ms in order to wait for long/complex MMI operations. The timeout
> work at TPDU 2nd level and not at LPDU 1st level of communication stack.
> 
> * In "en50221_stdcam_llci_destroy", all data from the CA device are read
> before closing the device. This prevent from keeping the last poll reply
> in the dvb_core module ringbuffer. The polling function used to keep
> contact with the CAM is first reading data then writing data, so there
> is always a reply left in the buffer.
> 
> * In "llci_lookup_callback", some tests permitting resource usage limit
> are disabled as they are not working correctly. When a new session is
> created, it is declared. But when a session is closed, this isn't
> declared so a new session can't be opened a second time.
> 
> * In "llci_session_callback", a test was removed as it was duplicated.
> 
> * In "en50221_stdcam_llci_poll" and "llci_datetime_enquiry_callback", if
> the function "en50221_stdcam_llci_dvbtime" isn't called regularly, a
> wrong date/time is send to the CAM. So, if the time wasn't supplied, we
> send the UTC time from the system. Also, the "time_offset" parameter of
> the called function "en50221_app_datetime_send" has been set to -1 as we
> don't have the "local_offset" information and as this information is
> optional (see the specification).
> 
> Best regards,
> Sebastien RAILLARD.




