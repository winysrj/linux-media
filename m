Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ysangkok@gmail.com>) id 1JSjkb-0003SH-9a
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 03:04:29 +0100
Received: by rv-out-0910.google.com with SMTP id b22so450646rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 18:04:23 -0800 (PST)
Message-ID: <15a344380802221804v1c4cf298oa80ac3552eb645ff@mail.gmail.com>
Date: Sat, 23 Feb 2008 03:04:23 +0100
From: Ysangkok <ysangkok@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <15a344380802221801n70ba6595o61e7df8d34bca116@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_3337_19513360.1203732263586"
References: <15a344380802220720j4ce3a2f0y8401c4e9b90bb553@mail.gmail.com>
	<15a344380802220739i15ba0739na6372c8b61695fca@mail.gmail.com>
	<20080222204943.GA16321@aidi.santinoli.com>
	<15a344380802221801n70ba6595o61e7df8d34bca116@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge WinTV Nova-T Stick problems
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

------=_Part_3337_19513360.1203732263586
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello David,

 I modprobe'd mt2060, however it doesn't render any additional lines in
 dmesg. The module does show up in lsmod (attached).

 Anyway, I forgot to tell you that I _did_ compile the latest linux-dvb
 git tree (about three days ago), however I am using the default Ubuntu
 kernel (2.6.22-14-generic). However if I compiled my own linux-dvb I
 understood that I did not need to have the absolute latest kernel.

 Next time I reboot I'll check what makes it show all those error
 messages in dmesg.

 I have an old syslog which has all the error messages, which look like this:

 Feb 21 09:44:35 Gigabob kernel: [  541.199844] dib0700: RC Query Failed
 Feb 21 09:44:35 Gigabob kernel: [  541.199856] dvb-usb: error while
 querying for an remote control event.
 Feb 21 09:44:35 Gigabob kernel: [  541.351680] dib0700: RC Query Failed
 Feb 21 09:44:35 Gigabob kernel: [  541.351692] dvb-usb: error while
 querying for an remote control event.
 Feb 21 09:44:35 Gigabob kernel: [  541.503522] dib0700: RC Query Failed
 Feb 21 09:44:35 Gigabob kernel: [  541.503538] dvb-usb: error while
 querying for an remote control event.
 Feb 21 09:44:36 Gigabob kernel: [  541.655351] dib0700: RC Query Failed

 And it goes on like that :P

 The full syslog is 2,5 MB. I can upload if you wan't it, but there is
 not anything special.

 Regards,
 Ysangkok

 2008/2/22, David Santinoli <marauder@tiscali.it>:

> On Fri, Feb 22, 2008 at 04:39:05PM +0100, Ysangkok wrote:
 >  > However I cannot get it to work. I have fetched the firmware
 >  > dvb-usb-dib0700-1.10.fw (34306 bytes). When I use (dvb)scan I get
 >  > "tuning failed".
 >
 >
 > Hi Ysangkok,
 >   I have a Nova-T Stick very similar to yours (mine has USB
 >  vendor:product ID 2040:7060 while yours is 2040:7070).  Assuming the
 >  hardware is substantially the same, you might want to 'modprobe mt2060'
 >  and check for this line in the dmesg output:
 >
 >  MT2060: successfully identified (IF1 = 1220)
 >
 >  Cheers,
 >
 >  David
 >

------=_Part_3337_19513360.1203732263586
Content-Type: application/octet-stream; name=lsmod
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fczisvce
Content-Disposition: attachment; filename=lsmod

TW9kdWxlICAgICAgICAgICAgICAgICAgU2l6ZSAgVXNlZCBieQptdDIwNjAgICAgICAgICAgICAg
ICAgICA2Mjc2ICAwIApkdmJfdXNiX2RpYjA3MDAgICAgICAgIDI4MTY4ICAwIApkaWI3MDAwcCAg
ICAgICAgICAgICAgIDE3NjcyICAyIGR2Yl91c2JfZGliMDcwMApkaWI3MDAwbSAgICAgICAgICAg
ICAgIDE2NTE2ICAxIGR2Yl91c2JfZGliMDcwMApkdmJfdXNiICAgICAgICAgICAgICAgIDIzMDUy
ICAxIGR2Yl91c2JfZGliMDcwMApkdmJfY29yZSAgICAgICAgICAgICAgIDgwNjY4ICAxIGR2Yl91
c2IKZGliMzAwMG1jICAgICAgICAgICAgICAxMzk2MCAgMSBkdmJfdXNiX2RpYjA3MDAKZGlieDAw
MF9jb21tb24gICAgICAgICAgNDk5NiAgMyBkaWI3MDAwcCxkaWI3MDAwbSxkaWIzMDAwbWMKZGli
MDA3MCAgICAgICAgICAgICAgICAgOTIyMCAgMiBkdmJfdXNiX2RpYjA3MDAKYmluZm10X21pc2Mg
ICAgICAgICAgICAxMjkzNiAgMSAKcmZjb21tICAgICAgICAgICAgICAgICA0MjEzNiAgMiAKcHBk
ZXYgICAgICAgICAgICAgICAgICAxMDI0NCAgMCAKc3BlZWRzdGVwX2xpYiAgICAgICAgICAgNjQw
NCAgMCAKY3B1ZnJlcV9wb3dlcnNhdmUgICAgICAgMjY4OCAgMCAKY3B1ZnJlcV9zdGF0cyAgICAg
ICAgICAgNzIzMiAgMCAKY3B1ZnJlcV91c2Vyc3BhY2UgICAgICAgNTI4MCAgMCAKY3B1ZnJlcV9v
bmRlbWFuZCAgICAgICAgOTYxMiAgMCAKY3B1ZnJlcV9jb25zZXJ2YXRpdmUgICAgIDgwNzIgIDAg
CmZyZXFfdGFibGUgICAgICAgICAgICAgIDU3OTIgIDIgY3B1ZnJlcV9zdGF0cyxjcHVmcmVxX29u
ZGVtYW5kCnZpZGVvICAgICAgICAgICAgICAgICAgMTgwNjAgIDAgCmNvbnRhaW5lciAgICAgICAg
ICAgICAgIDU1MDQgIDAgCnNicyAgICAgICAgICAgICAgICAgICAgMTk1OTIgIDAgCmJ1dHRvbiAg
ICAgICAgICAgICAgICAgIDg5NzYgIDAgCmRvY2sgICAgICAgICAgICAgICAgICAgMTA2NTYgIDAg
CmFjICAgICAgICAgICAgICAgICAgICAgIDYxNDggIDAgCmJhdHRlcnkgICAgICAgICAgICAgICAg
MTEwMTIgIDAgCmFlc19pNTg2ICAgICAgICAgICAgICAgMzQzMDQgIDAgCmRtX2NyeXB0ICAgICAg
ICAgICAgICAgMTQ5ODQgIDAgCmRtX21vZCAgICAgICAgICAgICAgICAgNTg4MTYgIDEgZG1fY3J5
cHQKaGlkcCAgICAgICAgICAgICAgICAgICAyMTI0OCAgMiAKbDJjYXAgICAgICAgICAgICAgICAg
ICAyNjI0MCAgMTIgcmZjb21tLGhpZHAKYmx1ZXRvb3RoICAgICAgICAgICAgICA1NzA2MCAgNSBy
ZmNvbW0saGlkcCxsMmNhcApzYnAyICAgICAgICAgICAgICAgICAgIDI0MDcyICAwIApwYXJwb3J0
X3BjICAgICAgICAgICAgIDM3NDEyICAwIApscCAgICAgICAgICAgICAgICAgICAgIDEyNTgwICAw
IApwYXJwb3J0ICAgICAgICAgICAgICAgIDM3NDQ4ICAzIHBwZGV2LHBhcnBvcnRfcGMsbHAKc25k
X2VtdTEwazFfc3ludGggICAgICAgODE5MiAgMCAKc25kX2VtdXhfc3ludGggICAgICAgICAzNTQ1
NiAgMSBzbmRfZW11MTBrMV9zeW50aApzbmRfc2VxX3Zpcm1pZGkgICAgICAgICA4MDY0ICAxIHNu
ZF9lbXV4X3N5bnRoCnNuZF9zZXFfbWlkaV9lbXVsICAgICAgIDc2ODAgIDEgc25kX2VtdXhfc3lu
dGgKc25kX2VtdTEwazEgICAgICAgICAgIDEzNzI0OCAgNCBzbmRfZW11MTBrMV9zeW50aApzbmRf
YWM5N19jb2RlYyAgICAgICAgMTAwNjQ0ICAxIHNuZF9lbXUxMGsxCmFjOTdfYnVzICAgICAgICAg
ICAgICAgIDMyMDAgIDEgc25kX2FjOTdfY29kZWMKc25kX3BjbV9vc3MgICAgICAgICAgICA0NDY3
MiAgMCAKc25kX21peGVyX29zcyAgICAgICAgICAxNzY2NCAgMSBzbmRfcGNtX29zcwpzbmRfcGNt
ICAgICAgICAgICAgICAgIDgwMzg4ICA0IHNuZF9lbXUxMGsxLHNuZF9hYzk3X2NvZGVjLHNuZF9w
Y21fb3NzCnNuZF9wYWdlX2FsbG9jICAgICAgICAgMTE0MDAgIDIgc25kX2VtdTEwazEsc25kX3Bj
bQpzbmRfdXRpbF9tZW0gICAgICAgICAgICA1NzYwICAyIHNuZF9lbXV4X3N5bnRoLHNuZF9lbXUx
MGsxCnNuZF9od2RlcCAgICAgICAgICAgICAgMTAyNDQgIDIgc25kX2VtdXhfc3ludGgsc25kX2Vt
dTEwazEKam95ZGV2ICAgICAgICAgICAgICAgICAxMTMyOCAgMCAKc25kX3NlcV9kdW1teSAgICAg
ICAgICAgNDc0MCAgMCAKc25kX3NlcV9vc3MgICAgICAgICAgICAzMzE1MiAgMCAKc25kX3NlcV9t
aWRpICAgICAgICAgICAgOTYwMCAgMCAKc25kX3Jhd21pZGkgICAgICAgICAgICAyNTcyOCAgMyBz
bmRfc2VxX3Zpcm1pZGksc25kX2VtdTEwazEsc25kX3NlcV9taWRpCnVzYmhpZCAgICAgICAgICAg
ICAgICAgMjk1MzYgIDAgCmhpZCAgICAgICAgICAgICAgICAgICAgMjg5MjggIDIgaGlkcCx1c2Jo
aWQKbnZpZGlhICAgICAgICAgICAgICAgNzgyMjMzNiAgNDIgCnNuZF9zZXFfbWlkaV9ldmVudCAg
ICAgIDg0NDggIDMgc25kX3NlcV92aXJtaWRpLHNuZF9zZXFfb3NzLHNuZF9zZXFfbWlkaQppZGVf
Y2QgICAgICAgICAgICAgICAgIDMyNjcyICAwIApjZHJvbSAgICAgICAgICAgICAgICAgIDM3NTM2
ICAxIGlkZV9jZAp4cGFkICAgICAgICAgICAgICAgICAgICA5OTg4ICAwIAppZGVfZGlzayAgICAg
ICAgICAgICAgIDE4NTYwICAyIApzbmRfc2VxICAgICAgICAgICAgICAgIDUzMjMyICA5IHNuZF9l
bXV4X3N5bnRoLHNuZF9zZXFfdmlybWlkaSxzbmRfc2VxX21pZGlfZW11bCxzbmRfc2VxX2R1bW15
LHNuZF9zZXFfb3NzLHNuZF9zZXFfbWlkaSxzbmRfc2VxX21pZGlfZXZlbnQKcHNtb3VzZSAgICAg
ICAgICAgICAgICAzOTk1MiAgMCAKc2VyaW9fcmF3ICAgICAgICAgICAgICAgODA2OCAgMCAKaTJj
X3ZpYXBybyAgICAgICAgICAgICAxMDAwNCAgMCAKaTJjX2NvcmUgICAgICAgICAgICAgICAyNjEx
MiAgMTAgbXQyMDYwLGR2Yl91c2JfZGliMDcwMCxkaWI3MDAwcCxkaWI3MDAwbSxkdmJfdXNiLGRp
YjMwMDBtYyxkaWJ4MDAwX2NvbW1vbixkaWIwMDcwLG52aWRpYSxpMmNfdmlhcHJvCmVtdTEwazFf
Z3AgICAgICAgICAgICAgIDQ3MzYgIDAgCmdhbWVwb3J0ICAgICAgICAgICAgICAgMTY3NzYgIDIg
ZW11MTBrMV9ncApzbmRfdGltZXIgICAgICAgICAgICAgIDI0MzI0ICAzIHNuZF9lbXUxMGsxLHNu
ZF9wY20sc25kX3NlcQpzbmRfc2VxX2RldmljZSAgICAgICAgICA5MjI4ICA4IHNuZF9lbXUxMGsx
X3N5bnRoLHNuZF9lbXV4X3N5bnRoLHNuZF9lbXUxMGsxLHNuZF9zZXFfZHVtbXksc25kX3NlcV9v
c3Msc25kX3NlcV9taWRpLHNuZF9yYXdtaWRpLHNuZF9zZXEKc25kICAgICAgICAgICAgICAgICAg
ICA1NDY2MCAgMTggc25kX2VtdXhfc3ludGgsc25kX3NlcV92aXJtaWRpLHNuZF9lbXUxMGsxLHNu
ZF9hYzk3X2NvZGVjLHNuZF9wY21fb3NzLHNuZF9taXhlcl9vc3Msc25kX3BjbSxzbmRfaHdkZXAs
c25kX3NlcV9vc3Msc25kX3Jhd21pZGksc25kX3NlcSxzbmRfdGltZXIsc25kX3NlcV9kZXZpY2UK
c291bmRjb3JlICAgICAgICAgICAgICAgODgwMCAgMSBzbmQKcGNzcGtyICAgICAgICAgICAgICAg
ICAgNDIyNCAgMCAKdmlhX2FncCAgICAgICAgICAgICAgICAxMTI2NCAgMSAKYWdwZ2FydCAgICAg
ICAgICAgICAgICAzNTAxNiAgMiBudmlkaWEsdmlhX2FncApzaHBjaHAgICAgICAgICAgICAgICAg
IDM0NTgwICAwIApwY2lfaG90cGx1ZyAgICAgICAgICAgIDMyNzA0ICAxIHNocGNocAppcHY2ICAg
ICAgICAgICAgICAgICAgMjczODkyICAzMCAKbmxzX2NwNDM3ICAgICAgICAgICAgICAgNjc4NCAg
MCAKbmxzX2lzbzg4NTlfMSAgICAgICAgICAgNTEyMCAgNiAKY2lmcyAgICAgICAgICAgICAgICAg
IDIzNzQyOCAgNiAKZXZkZXYgICAgICAgICAgICAgICAgICAxMTEzNiAgNCAKcmVpc2VyZnMgICAg
ICAgICAgICAgIDI0ODcwNCAgMSAKc2cgICAgICAgICAgICAgICAgICAgICAzNjc2NCAgMCAKc2Rf
bW9kICAgICAgICAgICAgICAgICAzMDMzNiAgMyAKdmlhODJjeHh4ICAgICAgICAgICAgICAxMDM3
MiAgMCBbcGVybWFuZW50XQppZGVfY29yZSAgICAgICAgICAgICAgMTE2ODA0ICAzIGlkZV9jZCxp
ZGVfZGlzayx2aWE4MmN4eHgKdmlhX3JoaW5lICAgICAgICAgICAgICAyNTk5MiAgMCAKbWlpICAg
ICAgICAgICAgICAgICAgICAgNjUyOCAgMSB2aWFfcmhpbmUKb2hjaTEzOTQgICAgICAgICAgICAg
ICAzNjUyOCAgMCAKaWVlZTEzOTQgICAgICAgICAgICAgICA5NjMxMiAgMiBzYnAyLG9oY2kxMzk0
CmZsb3BweSAgICAgICAgICAgICAgICAgNjAwMDQgIDAgCmVoY2lfaGNkICAgICAgICAgICAgICAg
MzY0OTIgIDAgCnVoY2lfaGNkICAgICAgICAgICAgICAgMjY2NDAgIDAgCnVzYmNvcmUgICAgICAg
ICAgICAgICAxMzg2MzIgIDcgZHZiX3VzYl9kaWIwNzAwLGR2Yl91c2IsdXNiaGlkLHhwYWQsZWhj
aV9oY2QsdWhjaV9oY2QKYXRhX2dlbmVyaWMgICAgICAgICAgICAgODQ1MiAgMCAKc2F0YV92aWEg
ICAgICAgICAgICAgICAxMjU0OCAgMiAKbGliYXRhICAgICAgICAgICAgICAgIDEyNTE2OCAgMiBh
dGFfZ2VuZXJpYyxzYXRhX3ZpYQpzY3NpX21vZCAgICAgICAgICAgICAgMTQ3MDg0ICA0IHNicDIs
c2csc2RfbW9kLGxpYmF0YQp0aGVybWFsICAgICAgICAgICAgICAgIDE0MzQ0ICAwIApwcm9jZXNz
b3IgICAgICAgICAgICAgIDMyMDcyICAxIHRoZXJtYWwKZmFuICAgICAgICAgICAgICAgICAgICAg
NTc2NCAgMCAKZnVzZSAgICAgICAgICAgICAgICAgICA0NzEyNCAgMyAKYXBwYXJtb3IgICAgICAg
ICAgICAgICA0MDcyOCAgMCAKY29tbW9uY2FwICAgICAgICAgICAgICAgODMyMCAgMSBhcHBhcm1v
cgo=
------=_Part_3337_19513360.1203732263586
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_3337_19513360.1203732263586--
