Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1KE1S2-0000Yy-1p
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 14:28:47 +0200
Received: by gv-out-0910.google.com with SMTP id n29so77214gve.16
	for <linux-dvb@linuxtv.org>; Wed, 02 Jul 2008 05:28:42 -0700 (PDT)
Message-ID: <e37d7f810807020528h6542dcf9ge439b972efff57e2@mail.gmail.com>
Date: Wed, 2 Jul 2008 13:28:42 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <486B6BB2.7060708@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1446_10407420.1215001722269"
References: <e37d7f810807020442q13107177n5a90b11faf51194d@mail.gmail.com>
	<486B6BB2.7060708@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0(ULi M9207) initialising OK but
	no response from scan
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_1446_10407420.1215001722269
Content-Type: multipart/alternative;
	boundary="----=_Part_1447_5939139.1215001722269"

------=_Part_1447_5939139.1215001722269
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/7/2 Antti Palosaari <crope@iki.fi>:

> terve Andrew,
> Andrew Websdale wrote:
>
>> Hi All,
>>
>> I've been trying to amend the M920x driver to cope with the MT2060 tuner.
>> My dmesg output looks encouraging :
>> usb 5-1: new high speed USB device using ehci_hcd and address 5
>> usb 5-1: configuration #1 chosen from 1 choice
>> Probing for m920x device at interface 0
>> dvb-usb: found a 'Dposh(mt2060 tuner) DVB-T USB2.0' in warm state.
>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>> demuxer.
>> DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)
>> m920x_mt352_frontend_attach
>> DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
>> m920x_mt2060_tuner_attach
>> MT2060: successfully identified (IF1 = 1220)
>> dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully initialized and
>> connected.
>>  but scanning produces no result. I thought it might be the firmware so I
>> used USBSnoop ( ver 2.0 from here <
>> http://www.pcausa.com/Utilities/UsbSnoop/SniffUSB-x86-2.0.0006.zip>  , I
>> think its slightly easier to use than the original) and extracted a new
>> firmware file (attached) . The firmware loaded without complaint, but still
>> no scan result. I'm a bit stuck now, anyone got any suggestions as to how I
>> should proceed?
>>
>
> I have following list to check:
> 1) firmware (you tested this one already)
> 2) demodulator (it is MT352 I think, but configuration / settings could be
> wrong)
> 3) wrong endpoint used for mpeg ts
>
> I can help if you take sniffs with usbsnoop, but hopefully you will find
> error yourself.
> http://benoit.papillault.free.fr/usbsnoop/
>
> regards
> Antti
> --
> http://palosaari.fi/





1)Sorry, forgot to attach firmware I made from usbsnoop(here it is)
2)The front end is MT352 - which configs/settings may need tweaking?
3)Whereabouts is the mpeg ts endpoint defined/set?

I'll have another go with usbsnoop later & post the log if I don't get
anywhere

regards Andrew

------=_Part_1447_5939139.1215001722269
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2008/7/2 Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
terve Andrew,<br>
Andrew Websdale wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">
Hi All,<br>
<br>
I&#39;ve been trying to amend the M920x driver to cope with the MT2060 tuner. My dmesg output looks encouraging :<br>
usb 5-1: new high speed USB device using ehci_hcd and address 5<br>
usb 5-1: configuration #1 chosen from 1 choice<br>
Probing for m920x device at interface 0<br>
dvb-usb: found a &#39;Dposh(mt2060 tuner) DVB-T USB2.0&#39; in warm state.<br>
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)<br>
m920x_mt352_frontend_attach<br>
DVB: registering frontend 0 (Zarlink MT352 DVB-T)...<br>
m920x_mt2060_tuner_attach<br>
MT2060: successfully identified (IF1 = 1220)<br>
dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully initialized and connected.<br></div>
 &nbsp;but scanning produces no result. I thought it might be the firmware so I used USBSnoop ( ver 2.0 from here &lt;<a href="http://www.pcausa.com/Utilities/UsbSnoop/SniffUSB-x86-2.0.0006.zip" target="_blank">http://www.pcausa.com/Utilities/UsbSnoop/SniffUSB-x86-2.0.0006.zip</a>&gt; &nbsp;, I think its slightly easier to use than the original) and extracted a new firmware file (attached) . The firmware loaded without complaint, but still no scan result. I&#39;m a bit stuck now, anyone got any suggestions as to how I should proceed?<br>

</blockquote>
<br>
I have following list to check:<br>
1) firmware (you tested this one already)<br>
2) demodulator (it is MT352 I think, but configuration / settings could be wrong)<br>
3) wrong endpoint used for mpeg ts<br>
<br>
I can help if you take sniffs with usbsnoop, but hopefully you will find error yourself.<br>
<a href="http://benoit.papillault.free.fr/usbsnoop/" target="_blank">http://benoit.papillault.free.fr/usbsnoop/</a><br>
<br>
regards<br>
Antti<br><font color="#888888">
-- <br>
<a href="http://palosaari.fi/" target="_blank">http://palosaari.fi/</a></font></blockquote><div><br><br><br><br>1)Sorry, forgot to attach firmware I made from usbsnoop(here it is)<br></div></div>2)The front end is MT352 - which configs/settings may need tweaking?<br>
3)Whereabouts is the mpeg ts endpoint defined/set?<br><br>I&#39;ll have another go with usbsnoop later &amp; post the log if I don&#39;t get anywhere<br><br>regards Andrew<br><br><br>

------=_Part_1447_5939139.1215001722269--

------=_Part_1446_10407420.1215001722269
Content-Type: application/octet-stream; name=dvb-usb-dposh-01.fw.new
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi5wlltg0
Content-Disposition: attachment; filename=dvb-usb-dposh-01.fw.new

s0DDAEAAAgvU54+CjoPwCefwCefwCefwIgILgpD/CHSA8OSj8KPwo3QC8BILOBIJm5D/FHQh8NKq
0q8CC5yPgo6D7fAiAKBAwwBAABIBAAIAAABAmBQGkpUAAAAAAQEAAP//////D1VMaSBFbGVjdHJv
bmljcwlVTGkgTTkyMDYAAAAAAAAFVUxpMDGEQMMAQAAAAAAAAAAAAAAAVmVyIDAuOTUgMjAwNTEw
MTAAAAAAAAAAAAAAAAAAAAAJAikAAQEAwDIJBAAAAf///wAHBYECR0DDAEAAAAIBCQQAAQH///8A
BwWBAgACAQkEAQAB////AAcFggIAAgEJBAEBAf///wAHBYICAAIBBAMJBAoGAAIAAABAAZJAwwBA
AAAJBxkAAQEAwDIJBAAAAf///wAHBYECQAABewASCJd+gBILsOUkIOICgcLlIVR/cAKB4X/AEgT5
hSUshSYrhSe6QMMAQAAqhSgpf8QSBPmFJTCFJi+FJy6FKC0SBOLlMP58AOQlL3ii9uw+GPblKVRg
YAJB/OUqcAKB0CT7cAKB0BRgTyT9okDDAEAAcAKB0CT+YAJB1uUtFGAVBHAl5StwBX8QEgo45Su0
ARd/EIAQ5StwBX8gEgo45Su0AQV/IBII8HUh/3Ui/3Uj//NAwwBAAHUk/3sAegB5IX+8gcvlLCT+
YCoUYFIk/XACQacUcAJBvSQGYAKB0H4Af0ASCASUEuyUAFACQdF8AH0SQdGQAFSKQMMAQADkk3AS
EggAlCnslABQAoAEfAB9KUHREggAlEnslABQAoAEfAB9SUHR5StwFn4Af/MSCASUBOyUAFACgAR8
AH0Et0DDAEAAQdHlK2QBcBuQAFoSCL1+AH9bEggwUAasAq0DgAStM3wAQdHlK2QCcBuQAGoSCL1+
AH9rEggwUAasAq0DgAStM+9AwwBAAHwAgE3lK2QDYAKB0JAAehIIvX4Af3sSCDBQBqwCrQOABK0z
fACAKn4Af/cSCASUCuyUAFACgAR8AH0KgBR+AX9qQMMAQAABEggElBnslABQAoAEfAB9GRIGxYHQ
fwR+gBIL4O9EAv1/BH6AEgA4fwR+gBIL4O9EAf1/BH6AEgA4gdDlKVRgDkDDAEAAZEBgAoHQ9SH1
IvUj9STlKSDnAoEH5SpkInARdTH/hS0yhTKChTGD4PUkYfrlKmQjcDOQ/zDlLfB1NDLlNNOUALxA
wwBAAEAMkP844DDjBRIFBYDt5TRwC5D/MHQQ8HUk/4AGkP8z4PUkYfrlKmQkcCflLRRgCARwHZD/
UYAVkP9X4PUhkP8IQMMAQABW4PUikP9T4PUjkP9S4PUkgGjlKmQlcBwSCBh6AHkhrjESC7DkkP8K
8Pt6AHkhdID//oHN5SpkKmACgdB1JIDlgEDDAEAALcRUD//DlBBQMOUtVA/+cBN0UC/45v/TlABA
CHUkguUr9F/2vgET5S3EVA8kUPjm/3AHdSSB5StP9uSQ/wvwrTFAwwBAACR0gP/+gDflKmQicDl1
Mf+FLTLlLf9+/78KBYUrT4HQvv8Yv4AVEgjFEgA4fwp+ABILZ+T9rzKuMYADEgjFEgCYQMMAQAA4
Egi2gdDlKmQjcEiQAFKT05QAQBEgBQ4SCNESC2cSCN0SC2fSBZD/MOUt8JD/MuUr8HU0MuU005QA
QAyQ/zjgy0DDAEAAMOMFEgUFgO3lNHBEkP8wdBDwgDzlKmQlcDYgAwqFK02FLEzSA4AphStLhSxK
EggYegB5Sq4xEgAD5JD/CvDCAxZAwwBAAIAO5PUhdSKAEgiQfoASAAPk9SF1Iv8SCJB+gBIAAxIE
4iLk9SH1IvUjdSQB+3oAeSF/vH6AEgADInsAegB5JX5fQMMAQACAEguwIhU0fzJ+ABILZyKOP49A
jEGNQnRAZUBwBHQAZT9wYuVCRUFwGPt6AHlD/36AEguw5UYw5gXk9U6AA3VOGkDDAEAAAeVCZA5F
QXAMkABak9OUAEADfwEi5UJkD0VBcAyQAGqT05QAQAN/AiLlQmQQRUFwDJAAepPTlABAA38DIuVC
kBdAwwBAAABAk/8idKplQHAEdABlP3BekABUk2QBcCDlQmQCRUFwA39JIuVCZANFQXAC/yLlQmQE
RUFwA38CIuVOcCrlQmSLQMMAQAAmRUFwA39AIuVCZCdFQXAC/yLlQmRGRUFwA39AIuVCZEdFQXAC
/yLlQpAAqpP/InTztUANdAC1PwjlQpAA85P/2UDDAEAAInRbZUBwBHQAZT9wJuVCRUFwBZAAWoBi
EgjpcAN/AyLlQiDgCxIIUCRb9YJ0AIBnfwAidGtlQHAEdABlP3Am5RtAwwBAAEJFQXAFkABqgDAS
COlwA38DIuVCIOALEghQJGv1gnQAgDV/ACJ0e2VAcAR0AGU/cDDlQkVBcAqQAHqTJeAkAv8yQMMA
QAAiEgjpcAN/AyLlQiDgEBIIUCR79YJ0AD71g+ST/yJ/ACJ097VADXQAtT8I5UKQAPeT/yJ0AbVA
DHQBtT8H5UKQQ0DDAEAAAQGT/yKONY825PU37a4EeALOwxPOE9j59TjtVAP1OeT1OuU6w5U4UFMS
B7yPPhIHio87EghhEgAD5TpkD2AM5VZAwwBAADpkH2AG5TpkL3AtdTyA5Tww5w97AHoAeTt/BH6A
EguwgOzk9Tv1PPU9dT4B+3oAeTt/vH6AEgADBTrB4uU505RAQMMAQAAAQEPlOST+YBwUYC0kAnA2
Ege8jzvkkP8L8K07dID//hIAOIAhEgfMjzwSB8yPO3QBEghdEgvqgA0SB4qPO3QDwUDDAEAAEghd
EgADEgi2Iq83BTfv/XwArzauNRIFD489rzcFN+/9fACvNq41EgUPjzyvNwU37/18AK82rjUSBQ8i
rzcFN95AwwBAAO/9fACvNq41EgUPIq83BTfv/XwArzauNRIFDyKQ/wt0AfB7AHoAeUd/WH6AEgvD
Egi25Ugw5AMSARoiAAAAAABHQMMAQAB+AH+qeKHm/Ajm/cMiewB/DHoAeTV+gCLlLv58AOQlLf/s
PvUxjzLlT5D/CvB7ACL9eKHm+gjm+8Od6pQAInsAcEDDAEAAegB5IX6AIpAAUuST05QAIiT+/+VB
NP/DE/7vEyKQ/wvwewB6AHk7dID//iLk9TX1NnU3AnU48ft6AHk1/yLk9dJAwwBAADX1NnU3AnU4
8Pt6AHk1/yJ1I4B1JOL7egB5IX8EIuT1IfUi9SMi5PU19TZ1N0D1OPt6AHk1IpD/C3QC8CKTJeA5
QMMAQAAkAvUzIuSQ/wvwrSuvMq4xIpD/IeBEIPB/9H4BIpD/IeBEQPB/iH4TIuVCZAFFQSLvJOBg
ZCQQYAIhmhIIR0AOE0DDAEAAEgjREgtnEgjdEgtn0gVDSRCQAFPkk7QBEeT1NfU29Td1OAESCHd+
gYAFEghsfoISAAPlSTDlCuT1NfU2dTchgMxAwwBAAAjk9TX1NnU3ofU4+xIIDxIAAxIIpn8QgDwS
CEdQPENJIBIIbH6DEgAD5Ukw5A8SCA0SC7BTN38SCA0SAAPk9TWIQMMAQAD1NnU3IvU4+38YEggR
EgADEgimfxx+gBIAAyJ1TgF/EHhQ5PYI3/x/WBIIPhILsBIInnUkAX+8EgoiEgiedSQQykDDAEAA
f1QSCiISCJ51JIH7egB5If9+gBIAA3QCEggpegB5IX9AfoASC7BDIwF/QBIIPhIAAxIInnUkAn9E
Egot5JD/Co9AwwBAAPD1IfUidSOAdSTifwQSCi0SCEdADJD/I+BU3/BUv/DCBSL7egB5IX6AEgAD
Ivt6AHkhfoASAAMi7yTgYEYkEHB3QMMAQABgEghHQBeQ/yHgVN/wf/R+ARILZ5D/IeBUv/DCBeT1
NfU29Tf1OBIIiX6BEgADEgh+foISAAMSCrBTN38SCqJTeEDDAEAASe8iEghHUBkSCH5+gxIAA+VJ
MOQJEgqwQzeAEgqiU0nfInsAegB5NX8MfoASAAMiewB6AHk1fwx+gBILsCK7AaZAwwBAAAaJgoqD
4CJQAuciu/4C4yKJgoqD5JMiuwEM5YIp9YLlgzr1g+AiUAbpJYL45iK7/gbpJYL44iLlgin1guWD
OvXYQMMAQACD5JMiuwEGiYKKg/AiUAL3Irv+AfMi+LsBDeWCKfWC5YM69YPo8CJQBuklgsj2Irv+
BeklgsjyItKI0oqQ/xF0RkDDAEAA//CQ/xPwkP8adAHwkP8edAPwkP8QdIDwkP8xdIjwkP9QdIDw
o/Ai5P38w+2f7J5QEO0kAfU65Dz1OQ29AAEMgJJAwwBAAOkiwODAg8CCwqqQ/xPg9QnlCfDSANCC
0IPQ4DISCLYwAP3lCTDgAxIH3MIA0qqA74+CjoPg9Qjg9wng9wng9wlENMMAQADg9yKPgo6D4PUI
j4KOg+D3CeD3Inh/5PbY/XWBogIAFo+CjoPg9Qjg/yLnj4KOg/AJ5/AiAAAAAAAAAAAAAAAA
------=_Part_1446_10407420.1215001722269
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_1446_10407420.1215001722269--
