Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2E1Ncy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 09:32:54 -0400
Message-ID: <4FC37E7D.5020106@redhat.com>
Date: Mon, 28 May 2012 10:32:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] Add a keymap for FireDTV board
References: <1338210875-4620-1-git-send-email-mchehab@redhat.com> <20120528152937.75049a69@stein>
In-Reply-To: <20120528152937.75049a69@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 10:29, Stefan Richter escreveu:
> On May 28 Mauro Carvalho Chehab wrote:
>> --- a/include/media/rc-map.h
>> +++ b/include/media/rc-map.h
>> @@ -158,6 +158,7 @@ void rc_map_init(void);
>>  #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
>>  #define RC_MAP_WINFAST                   "rc-winfast"
>>  #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
>> +#define RC_MAP_FIREDTV			 "rc-firedtv"
>>  
>>  /*
>>   * Please, do not just append newer Remote Controller names at the end.
> 
> The comment says that names should be inserted in alphabetical order. :-)

Gah! you got me ;)

I'll merge the enclosed diff on it, to fix it.

Regards,
Mauro

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index adc6f28..29a54db 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -93,6 +93,7 @@ void rc_map_init(void);
 #define RC_MAP_ENCORE_ENLTV              "rc-encore-enltv"
 #define RC_MAP_EVGA_INDTUBE              "rc-evga-indtube"
 #define RC_MAP_EZTV                      "rc-eztv"
+#define RC_MAP_FIREDTV			 "rc-firedtv"
 #define RC_MAP_FLYDVB                    "rc-flydvb"
 #define RC_MAP_FLYVIDEO                  "rc-flyvideo"
 #define RC_MAP_FUSIONHDTV_MCE            "rc-fusionhdtv-mce"
@@ -158,7 +159,6 @@ void rc_map_init(void);
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
-#define RC_MAP_FIREDTV			 "rc-firedtv"
 
 /*
  * Please, do not just append newer Remote Controller names at the end.
