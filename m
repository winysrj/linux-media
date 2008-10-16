Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KqZsx-0002U3-0P
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 22:55:58 +0200
Received: from geppetto.reilabs.com (78.15.189.104) by relay-pt1.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48F6844E00009C30 for linux-dvb@linuxtv.org;
	Thu, 16 Oct 2008 22:55:51 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KqZry-00020C-SJ
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 22:54:54 +0200
Date: Thu, 16 Oct 2008 22:54:54 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb@linuxtv.org
Message-ID: <20081016205454.GA32397@geppetto>
References: <20081014212402.GB11745@geppetto> <20081015232121.GA8831@geppetto>
	<48F73F56.7060805@verizonbusiness.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48F73F56.7060805@verizonbusiness.com>
Subject: Re: [linux-dvb] Unable to query frontend status with dvbscan
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

On date Thursday 2008-10-16 07:19:18 -0600, Mark Paulus wrote:
> Stefano Sabatini wrote:
>> On date Tuesday 2008-10-14 23:24:02 +0200, Stefano Sabatini wrote:
>>> Hi all,
>>>
>>> can you say what's the meaning of such a message?
>>>
>>> I'm using it with:
>>> dvbscan  /usr/share/dvb/dvb-t/it-MyCity
>>> Unable to query frontend status
>>>
>>> using a TerraTec Electronic GmbH with dvb-usb-dib0700 driver.
>>>
>>> The module seems to be loaded correctly, indeed I get this in the
>>> kernel log:
>>>
>>> [ 1834.456051] dib0700: loaded with support for 7 different device-types
>>> [ 1834.456051] dvb-usb: found a 'Terratec Cinergy HT USB XE' in cold state, will try to load a firmware
>>> [ 1834.456051] firmware: requesting dvb-usb-dib0700-1.10.fw
>>> [ 1834.464197] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
>>> [ 1834.662979] dib0700: firmware started successfully.
>>> [ 1835.168928] dvb-usb: found a 'Terratec Cinergy HT USB XE' in warm state.
>>> [ 1835.168997] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
>>> [ 1835.169355] DVB: registering new adapter (Terratec Cinergy HT USB XE)
>>> [ 1835.419963] DVB: registering frontend 0 (DiBcom 7000PC)...
>>> [ 1835.499932] xc2028 1-0061: creating new instance
>>> [ 1835.499932] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>>> [ 1835.499932] input: IR-receiver inside an USB DVB receiver as /class/input/input7
>>> [ 1835.510406] dvb-usb: schedule remote query interval to 150 msecs.
>>> [ 1835.510416] dvb-usb: Terratec Cinergy HT USB XE successfully initialized and connected.
>>> [ 1835.510696] usbcore: registered new interface driver dvb_usb_dib0700
>>>
>>> The led on the device switched on when I performed the first scan.
>>
>> Other meaningful info:
>> stefano@geppetto ~> dvbscan  /usr/share/dvb/dvb-t/it-Cagliari
>> Unable to query frontend status
>> stefano@geppetto ~> sudo dvbscan  /usr/share/dvb/dvb-t/it-Cagliari
>> Unable to query frontend status
>> stefano@geppetto ~> ls -l /dev/dvb/adapter0/
>> total 0
>> crw-rw---- 1 root video 212, 1 2008-09-23 00:04 audio0
>> crw-rw---- 1 root video 212, 6 2008-09-23 00:04 ca0
>> crw-rw---- 1 root video 212, 4 2008-09-23 00:04 demux0
>> crw-rw---- 1 root video 212, 5 2008-09-23 00:04 dvr0
>> crw-rw---- 1 root video 212, 3 2008-09-23 00:04 frontend0
>> crw-rw---- 1 root video 212, 7 2008-09-23 00:04 net0
>> crw-rw---- 1 root video 212, 8 2008-09-23 00:04 osd0
>> crw-rw---- 1 root video 212, 0 2008-09-23 00:04 video0
>>
>> stefano@geppetto ~> uname -a
>> Linux geppetto 2.6.26-1-686 #1 SMP Thu Oct 9 15:18:09 UTC 2008 i686 GNU/Linux
>>
>> The device is reported to be supported on the DVB wiki:
>> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_HT_USB_XE
>>
>> Help or hints will be appreciated.
>>
>> Regards.
>
> I believe I have seen a message like this when something else
> is talking to the card already.  For instance, I run my cards in a Mythtv 
> system, and in mythtv there is a setting to only attach to the card when 
> actually using the card.  If that
> setting is set incorrectly, mythtv will attach to the card at startup, 
> and keep exclusive use of the card, not allowing
> anyone else to access the card at all.

lsof didn't show any device accessing to device inside /dev/dvb.

But digging again in the web I found this:
http://forums.opensuse.org/archives/sf-archives/archives-software/archives-multimedia/340016-dvb-t-card-cant-scan-10-3-a.html

So the problem seems a regression in the dvb-apps.

And precisely the problem seems to be in the function:
libdvb/dvbfe.c:dvbfe_get_info()

Debugging I get this in dvbfe_get_info (second invocation during the
running of the application):

dvbfe_get_info (fehandle=0x8beb008, 
               querymask=DVBFE_INFO_LOCKSTATUS,
               result=0xbfada108, 
               querytype=DVBFE_INFO_QUERYTYPE_IMMEDIATE,
               timeout=0) at dvbfe.c:23

		if (querymask & DVBFE_INFO_LOCKSTATUS) {
			if (!ioctl(fehandle->fd, FE_READ_STATUS, &kevent.status)) {
				returnval |= DVBFE_INFO_LOCKSTATUS;
			}
		}

The result of the ioctl is 0 so the returnval is ored with
DVBFE_INFO_LOCKSTATUS (so set to 1), then we have in the main:

				if (dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &feinfo,
				    			DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0) !=
					DVBFE_INFO_QUERYTYPE_IMMEDIATE) {
					fprintf(stderr, "Unable to query frontend status\n");
					exit(1);
				}



which is different from DVBFE_INFO_QUERYTYPE_IMMEDIATE = 0, so the
exit, but I can really understand the logic here.

So what's the expected exit of the ioctl with FE_READ_STATUS?

Regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
