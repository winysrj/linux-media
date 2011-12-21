Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50092 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1LUDGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 22:06:35 -0500
Received: by wibhm6 with SMTP id hm6so1723516wib.19
        for <linux-media@vger.kernel.org>; Tue, 20 Dec 2011 19:06:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOy7-nOc9U4_BRKYyagcVtDZyr2Z9ZEUAftmdBsfBrWVVLFGjA@mail.gmail.com>
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
	<4EE9A8B6.4040102@matrix-vision.de>
	<CAOy7-nPY_Nffgj_Ax=ziT9WYH-egvL8QnZfb50Xurn+AF4yWCQ@mail.gmail.com>
	<4EE9C7A1.8060303@matrix-vision.de>
	<CAOy7-nOc9U4_BRKYyagcVtDZyr2Z9ZEUAftmdBsfBrWVVLFGjA@mail.gmail.com>
Date: Wed, 21 Dec 2011 11:06:33 +0800
Message-ID: <CAOy7-nM4-qVjgmgwATPHuUnpPmAggVpsLtJ48H932tweaQdY0Q@mail.gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input
 (Y12) is truncated to Y10 at the CCDC output?
From: James <angweiyang@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d043bdf14a0b3c704b491784a
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d043bdf14a0b3c704b491784a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Laurent & Michael,

On Wed, Dec 21, 2011 at 10:50 AM, James <angweiyang@gmail.com> wrote:
> Hi Michael & Laurent,
>
> On Thu, Dec 15, 2011 at 6:10 PM, Michael Jones
> <michael.jones@matrix-vision.de> wrote:
>> Hi James,
>
>> Laurent has a program 'media-ctl' to set up the pipeline (see
>> http://git.ideasonboard.org/?p=3Dmedia-ctl.git). =A0You will find many e=
xamples
>> of its usage in the archives of this mailing list. It will look somethin=
g
>> like:
>> media-ctl -r
>> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]'
>> media-ctl -l '"your-sensor-name":0 -> "OMAP3 ISP CCDC":0 [1]'
>>
>> you will also need to set the formats through the pipeline with 'media-c=
tl
>> --set-format'.
>>
>> After you use media-ctl to set up the pipeline, you can use yavta to cap=
ture
>> the data from the CCDC output (for me, this is /dev/video2).
>>
>>
>> -Michael
>
> I encountered some obstacles with the driver testing of my monochrome
> sensor on top of Steve's 3.0-pm branch. An NXP SC16IS750 I2C-UART
> bridge is used to 'transform' the sensor into a I2C device.
>
> The PCLK, VSYNC, HSYNC (640x512, 30Hz, fixed output format) are free
> running upon power-on the sensor unlike MT9V032 which uses the XCLKA
> to 'power-on/off' it.
>
> My steps,
>
> 1) media-ctl -r -l '"mono640":0->"OMAP3 ISP CCDC":0:[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
>
> 2) media-ctl -f '"mono640":0[Y12 640x512]", "OMAP3 ISP CCDC":1[Y12 640x51=
2]'
>
> Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/0
> Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/1
>
> 3) yavta -p -f Y12 -s 640x512 -n 4 --capture=3D61 --skip 1 -F `media-ctl
> -e "OMAP3 ISP CCDC output"` --file=3D./DCIM/Y12
>
> Unsupported video format 'Y12'
>
> Did I missed something?
> What parameters did you supplied to yavta to test the Y10/Y12
>
> Many thanks in adv.
> Sorry if duplicated emails received.
>
> --
> Regards,
> James

I changed the parameters for yavta from "-f Y12" to "-f Y16"

yavta -p -f Y16 -s 640x512 -n 2 --capture=3D10 --skip 5 -F `media-ctl -e
"OMAP3 ISP CCDC output"` --file=3D./DCIM/Y16

and there are 2 chunks of message at the console now and it ended with
"Unable to request buffers: Invalid argument (22).".

I've attached the logfile here. (mono640.log)

Hope you can assist me to grab the raw Y12 data to file.

Many thanks in adv.

--=20
Regards,
James

--f46d043bdf14a0b3c704b491784a
Content-Type: text/x-log; charset=US-ASCII; name="mono640.log"
Content-Disposition: attachment; filename="mono640.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwfrc83q0

cm9vdEBvdmVybzptZWRpYS1jdGwgLXIgLXYgLWwgJyJtb25vNjQwIjowLT4iT01BUDMgSVNQIEND
REMiOjBbMV0sICJPTUFQMyBJU1AgQ0NEQyI6MS0+Ik9NQVAzIElTUCBDQ0RDIG91dHB1dCI6MFsx
XScKCk9wZW5pbmcgbWVkaWEgZGV2aWNlIC9kZXYvbWVkaWEwCkVudW1lcmF0aW5nIGVudGl0aWVz
CkZvdW5kIDE2IGVudGl0aWVzCkVudW1lcmF0aW5nIHBhZHMgYW5kIGxpbmtzClJlc2V0dGluZyBh
bGwgbGlua3MgdG8gaW5hY3RpdmUKU2V0dGluZyB1cCBsaW5rIDE2OjAgLT4gNTowIFsxXQpTZXR0
aW5nIHVwIGxpbmsgNToxIC0+IDY6MCBbMV0KCnJvb3RAb3Zlcm86bWVkaWEtY3RsIC12IC1mICci
bW9ubzY0MCI6MFtZMTIgNjQweDUxMl0sICJPTUFQMyBJU1AgQ0NEQyI6MVtTR1JCRzEyIDY0MHg1
MTJdJwoKT3BlbmluZyBtZWRpYSBkZXZpY2UgL2Rldi9tZWRpYTAKRW51bWVyYXRpbmcgZW50aXRp
ZXMKRm91bmQgMTYgZW50aXRpZXMKRW51bWVyYXRpbmcgcGFkcyBhbmQgbGlua3MKU2V0dGluZyB1
cCBmb3JtYXQgWTEyIDY0MHg1MTIgb24gcGFkIG1vbm82NDAgMy0wMDRkLzAKRm9ybWF0IHNldDog
WTEyIDY0MHg1MTIKU2V0dGluZyB1cCBmb3JtYXQgWTEyIDY0MHg1MTIgb24gcGFkIE9NQVAzIElT
UCBDQ0RDLzAKRm9ybWF0IHNldDogWTEyIDY0MHg1MTIKU2V0dGluZyB1cCBmb3JtYXQgWTEyIDY0
MHg1MTIgb24gcGFkIE9NQVAzIElTUCBDQ0RDLzEKRm9ybWF0IHNldDogWTEyIDY0MHg1MTIKCgpy
b290QG92ZXJvOnlhdnRhIC1wIC1mIFkxNiAtcyA2NDB4NTEyIC1uIDIgLS1jYXB0dXJlPTEwIC0t
c2tpcCA1IC1GIGBtZWRpYS1jdGwgLWUgIk9NQVAzIElTUCBDQ0RDIG91dHB1dCJgIC0tZmlsZT0u
L0RDSU0vWTE2CgpEZXZpY2UgL2Rldi92aWRlbzIgb3BlbmVkLgotLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KV0FSTklORzogYXQgZHJpdmVycy9tZWRpYS92aWRlby9vbWFwM2lz
cC9pc3B2aWRlby5jOjIxOCBpc3BfdmlkZW9fc2V0X2Zvcm1hdCsweDUwLzB4ODggW29tYXAzX2lz
cF0oKQpEZXZpY2UgYE9NQVAzIElTUCBDQ0RDIG91dHB1dCcgb24gYG1lZGlhJyBpcyBhIHZpZGVv
IG9tYXBsZmIgY2FwdHVyZSBkZXZpY2UuCk1vZHVsZXMgbGlua2VkIGluOiBidWZmZXJjbGFzc190
aSBwdnJzcnZrbSBpcHY2IG1vbm82NDAgbGliZXJ0YXNfc2RpbyBvbWFwM19pc3AgbGliZXJ0YXMg
djRsMl9jb21tb24gY2ZnODAyMTEgdmlkZW9kZXYgbWVkaWEgbGliODAyMTEgZmlybXdhcmVfY2xh
c3MgYWRzNzg0NgpbPGMwMDQ1ZGM0Pl0gKHVud2luZF9iYWNrdHJhY2UrMHgwLzB4MTI4KSBmcm9t
IFs8YzAwNmJhOWM+XSAod2Fybl9zbG93cGF0aF9jb21tb24rMHg0Yy8weDY0KQpbPGMwMDZiYTlj
Pl0gKHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NGMvMHg2NCkgZnJvbSBbPGMwMDZiYWQwPl0gKHdh
cm5fc2xvd3BhdGhfbnVsbCsweDFjLzB4MjQpCls8YzAwNmJhZDA+XSAod2Fybl9zbG93cGF0aF9u
dWxsKzB4MWMvMHgyNCkgZnJvbSBbPGJmMDk5ZTkwPl0gKGlzcF92aWRlb19zZXRfZm9ybWF0KzB4
NTAvMHg4OCBbb21hcDNfaXNwXSkKWzxiZjA5OWU5MD5dIChpc3BfdmlkZW9fc2V0X2Zvcm1hdCsw
eDUwLzB4ODggW29tYXAzX2lzcF0pIGZyb20gWzxiZjAxZDc3OD5dIChfX3ZpZGVvX2RvX2lvY3Rs
KzB4MTFhNC8weDUxNmMgW3ZpZGVvZGV2XSkKWzxiZjAxZDc3OD5dIChfX3ZpZGVvX2RvX2lvY3Rs
KzB4MTFhNC8weDUxNmMgW3ZpZGVvZGV2XSkgZnJvbSBbPGJmMDFjNDU4Pl0gKHZpZGVvX3VzZXJj
b3B5KzB4MzQwLzB4NDUwIFt2aWRlb2Rldl0pCls8YmYwMWM0NTg+XSAodmlkZW9fdXNlcmNvcHkr
MHgzNDAvMHg0NTAgW3ZpZGVvZGV2XSkgZnJvbSBbPGJmMDFiNDQ4Pl0gKHY0bDJfaW9jdGwrMHg3
Yy8weDEyYyBbdmlkZW9kZXZdKQpbPGJmMDFiNDQ4Pl0gKHY0bDJfaW9jdGwrMHg3Yy8weDEyYyBb
dmlkZW9kZXZdKSBmcm9tIFs8YzAwZTQxMTA+XSAoZG9fdmZzX2lvY3RsKzB4NGIwLzB4NTFjKQpb
PGMwMGU0MTEwPl0gKGRvX3Zmc19pb2N0bCsweDRiMC8weDUxYykgZnJvbSBbPGMwMGU0MWI0Pl0g
KHN5c19pb2N0bCsweDM4LzB4NWMpCls8YzAwZTQxYjQ+XSAoc3lzX2lvY3RsKzB4MzgvMHg1Yykg
ZnJvbSBbPGMwMDQxMjQwPl0gKHJldF9mYXN0X3N5c2NhbGwrMHgwLzB4MzApCi0tLVsgZW5kIHRy
YWNlIDY4MjRiNzM1YmVlMTUwYjUgXS0tLQotLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KV0FSTklORzogYXQgZHJpdmVycy9tZWRpYS92aWRlby9vbWFwM2lzcC9pc3B2aWRlby5j
OjE3OCBpc3BfdmlkZW9fbWJ1c190b19waXgrMHg3OC8weDE0NCBbb21hcDNfaXNwXSgpCk1vZHVs
ZXMgbGlua2VkIGluOiBidWZmZXJjbGFzc190aSBvbWFwbGZiIHB2cnNydmttIGlwdjYgbW9ubzY0
MCBsaWJlcnRhc19zZGlvIG9tYXAzX2lzcCBsaWJlcnRhcyB2NGwyX2NvbW1vbiBjZmc4MDIxMSB2
aWRlb2RldiBtZWRpYSBsaWI4MDIxMSBmaXJtd2FyZV9jbGFzcyBhZHM3ODQ2Cls8YzAwNDVkYzQ+
XSAodW53aW5kX2JhY2t0cmFjZSsweDAvMHgxMjgpIGZyb20gWzxjMDA2YmE5Yz5dICh3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDRjLzB4NjQpCls8YzAwNmJhOWM+XSAod2Fybl9zbG93cGF0aF9jb21t
b24rMHg0Yy8weDY0KSBmcm9tIFs8YzAwNmJhZDA+XSAod2Fybl9zbG93cGF0aF9udWxsKzB4MWMv
MHgyNCkKWzxjMDA2YmFkMD5dICh3YXJuX3Nsb3dwYXRoX251bGwrMHgxYy8weDI0KSBmcm9tIFs8
YmYwOTliZmM+XSAoaXNwX3ZpZGVvX21idXNfdG9fcGl4KzB4NzgvMHgxNDQgW29tYXAzX2lzcF0p
Cls8YmYwOTliZmM+XSAoaXNwX3ZpZGVvX21idXNfdG9fcGl4KzB4NzgvMHgxNDQgW29tYXAzX2lz
cF0pIGZyb20gWzxiZjA5OWVhMD5dIChpc3BfdmlkZW9fc2V0X2Zvcm1hdCsweDYwLzB4ODggW29t
YXAzX2lzcF0pCls8YmYwOTllYTA+XSAoaXNwX3ZpZGVvX3NldF9mb3JtYXQrMHg2MC8weDg4IFtv
bWFwM19pc3BdKSBmcm9tIFs8YmYwMWQ3Nzg+XSAoX192aWRlb19kb19pb2N0bCsweDExYTQvMHg1
MTZjIFt2aWRlb2Rldl0pCls8YmYwMWQ3Nzg+XSAoX192aWRlb19kb19pb2N0bCsweDExYTQvMHg1
MTZjIFt2aWRlb2Rldl0pIGZyb20gWzxiZjAxYzQ1OD5dICh2aWRlb191c2VyY29weSsweDM0MC8w
eDQ1MCBbdmlkZW9kZXZdKQpbPGJmMDFjNDU4Pl0gKHZpZGVvX3VzZXJjb3B5KzB4MzQwLzB4NDUw
IFt2aWRlb2Rldl0pIGZyb20gWzxiZjAxYjQ0OD5dICh2NGwyX2lvY3RsKzB4N2MvMHgxMmMgW3Zp
ZGVvZGV2XSkKWzxiZjAxYjQ0OD5dICh2NGwyX2lvY3RsKzB4N2MvMHgxMmMgW3ZpZGVvZGV2XSkg
ZnJvbSBbPGMwMGU0MTEwPl0gKGRvX3Zmc19pb2N0bCsweDRiMC8weDUxYykKWzxjMDBlNDExMD5d
IChkb192ZnNfaW9jdGwrMHg0YjAvMHg1MWMpIGZyb20gWzxjMDBlNDFiND5dIChzeXNfaW9jdGwr
MHgzOC8weDVjKQpbPGMwMGU0MWI0Pl0gKHN5c19pb2N0bCsweDM4LzB4NWMpIGZyb20gWzxjMDA0
MTI0MD5dIChyZXRfZmFzdF9zeXNjYWxsKzB4MC8weDMwKQotLS1bIGVuZCB0cmFjZSA2ODI0Yjcz
NWJlZTE1MGI2IF0tLS0KVmlkZW8gZm9ybWF0IHNldDogICgwMDAwMDAwMCkgNjQweDUxMiBidWZm
ZXIgc2l6ZSAwClZpZGVvIGZvcm1hdDogICgwMDAwMDAwMCkgNjQweDUxMiBidWZmZXIgc2l6ZSAw
ClVuYWJsZSB0byByZXF1ZXN0IGJ1ZmZlcnM6IEludmFsaWQgYXJndW1lbnQgKDIyKS4KCg==
--f46d043bdf14a0b3c704b491784a--
