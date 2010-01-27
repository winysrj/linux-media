Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:38247 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0A0KCd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 05:02:33 -0500
Message-ID: <4B600FE8.5060205@crans.org>
Date: Wed, 27 Jan 2010 11:05:28 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: "pierre.gronlier" <ticapix@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: problem with libdvben50221 and powercam pro V4 [almost solved]
References: <4B5CA8F8.3000301@crans.ens-cachan.fr> <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com> <4B5CBF14.1000005@crans.ens-cachan.fr> <loom.20100124T225424-639@post.gmane.org> <4B5D6A6B.9030900@gmail.com>
In-Reply-To: <4B5D6A6B.9030900@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090502060609000903010007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090502060609000903010007
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

pierre.gronlier wrote:
> pierre gronlier wrote, On 01/24/2010 11:03 PM:
>> DUBOST Brice <dubost <at> crans.ens-cachan.fr> writes:
>>> Manu Abraham a écrit :
>>>> Hi Brice,
>>>>
>>>> On Mon, Jan 25, 2010 at 12:09 AM, DUBOST Brice
>>>> <dubost <at> crans.ens-cachan.fr> wrote:
>>>>> Hello
>>>>>
>>>>> Powercam just made a new version of their cam, the version 4
>>>>>
>>>>> Unfortunately this CAM doesn't work with gnutv and applications based on
>>>>> libdvben50221
>>>>>
>>>>> This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
>>>>> by stack:-3) after showing the supported ressource id.
>>>>>
>>>>> The problem is that this camreturns two times the list of supported ids
>>>>> (as shown in the log) this behavior make the llci_lookup_callback
>>>>> (en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
>>>>> at the second call because there is already a session number (in the
>>>>> test app the session number is not tested)
>>>>>
>>>>> I solved the problem commenting out the test for the session number as
>>>>> showed in the joined patch (against the latest dvb-apps, cloned today)
>> I will run some tests with a TT3200 card too and a Netup card tomorrow.
>>
>> Regarding the cam returning two times the list of valid cam ids, wouldn't be
>> better if the manufacturer corrects it in the cam firmware ?
>> What says the en50221 norm about it ?
>>
> 
> Indeed, with the patch applied, the command gnutv -adapter 0 -cammenu is
> working fine with a netup card too.
> 
> I will try to update to the last revision of pcam firmware (v4.2) and
> report this behaviour to the manufacturer.
> 


Hello, a bit more information on this issue

Just for information, Here I attach you the log of another test I did,
the CAM answers the list of available Ids several times (each time you
change it basically) on the same session.

Manu : the test in the libdvben50221 was intended to deal with which case ?

I notice also that the decoding can fail if the PMT_ASK is sent between
the two ca_list answer at the beginning (this is a bit boring).

Regards

-- 
Brice




--------------090502060609000903010007
Content-Type: text/plain;
 name="CAMpowercamV4.1.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="CAMpowercamV4.1.txt"

Rm91bmQgYSBDQU0gb24gYWRhcHRlcjEuLi4gd2FpdGluZy4uLgplbjUwMjIxX3RsX3JlZ2lz
dGVyX3Nsb3QKc2xvdGlkOiAwCnRjaWQ6IDEKUHJlc3MgYSBrZXkgdG8gZW50ZXIgbWVudQow
MDpIb3N0IG9yaWdpbmF0ZWQgdHJhbnNwb3J0IGNvbm5lY3Rpb24gMSBjb25uZWN0ZWQKMDA6
UHVibGljIHJlc291cmNlIGxvb2t1cCBjYWxsYmFjayAxIDEgMQowMDpDQU0gY29ubmVjdGlu
ZyB0byByZXNvdXJjZSAwMDAxMDA0MSwgc2Vzc2lvbl9udW1iZXIgMQowMDpDQU0gc3VjY2Vz
c2Z1bGx5IGNvbm5lY3RlZCB0byByZXNvdXJjZSAwMDAxMDA0MSwgc2Vzc2lvbl9udW1iZXIg
MQowMDp0ZXN0X3JtX3JlcGx5X2NhbGxiYWNrCjAwOnRlc3Rfcm1fZW5xX2NhbGxiYWNrCjAw
OlB1YmxpYyByZXNvdXJjZSBsb29rdXAgY2FsbGJhY2sgMiAxIDEKMDA6Q0FNIGNvbm5lY3Rp
bmcgdG8gcmVzb3VyY2UgMDAwMjAwNDEsIHNlc3Npb25fbnVtYmVyIDIKMDA6Q0FNIHN1Y2Nl
c3NmdWxseSBjb25uZWN0ZWQgdG8gcmVzb3VyY2UgMDAwMjAwNDEsIHNlc3Npb25fbnVtYmVy
IDIKMDA6dGVzdF9haV9jYWxsYmFjawogIEFwcGxpY2F0aW9uIHR5cGU6IDAxCiAgQXBwbGlj
YXRpb24gbWFudWZhY3R1cmVyOiAwMmNhCiAgTWFudWZhY3R1cmVyIGNvZGU6IDMwMDAKICBN
ZW51IHN0cmluZzogUENBTSBWNC4xCjAwOlB1YmxpYyByZXNvdXJjZSBsb29rdXAgY2FsbGJh
Y2sgMyAxIDEKMDA6Q0FNIGNvbm5lY3RpbmcgdG8gcmVzb3VyY2UgMDAwMzAwNDEsIHNlc3Np
b25fbnVtYmVyIDMKMDA6Q0FNIHN1Y2Nlc3NmdWxseSBjb25uZWN0ZWQgdG8gcmVzb3VyY2Ug
MDAwMzAwNDEsIHNlc3Npb25fbnVtYmVyIDMKMDA6dGVzdF9jYV9pbmZvX2NhbGxiYWNrCiAg
U3VwcG9ydGVkIENBIElEOiAwNTAwCjAwOkNvbm5lY3Rpb24gdG8gcmVzb3VyY2UgMDAwMzAw
NDEsIHNlc3Npb25fbnVtYmVyIDMgY2xvc2VkCjAwOlB1YmxpYyByZXNvdXJjZSBsb29rdXAg
Y2FsbGJhY2sgMyAxIDEKMDA6Q0FNIGNvbm5lY3RpbmcgdG8gcmVzb3VyY2UgMDAwMzAwNDEs
IHNlc3Npb25fbnVtYmVyIDMKMDA6Q0FNIHN1Y2Nlc3NmdWxseSBjb25uZWN0ZWQgdG8gcmVz
b3VyY2UgMDAwMzAwNDEsIHNlc3Npb25fbnVtYmVyIDMKMDA6dGVzdF9jYV9pbmZvX2NhbGxi
YWNrCiAgU3VwcG9ydGVkIENBIElEOiAwNTAwCgowMDpQdWJsaWMgcmVzb3VyY2UgbG9va3Vw
IGNhbGxiYWNrIDY0IDEgMQowMDpDQU0gY29ubmVjdGluZyB0byByZXNvdXJjZSAwMDQwMDA0
MSwgc2Vzc2lvbl9udW1iZXIgNAowMDpDQU0gc3VjY2Vzc2Z1bGx5IGNvbm5lY3RlZCB0byBy
ZXNvdXJjZSAwMDQwMDA0MSwgc2Vzc2lvbl9udW1iZXIgNAowMDp0ZXN0X21taV9kaXNwbGF5
X2NvbnRyb2xfY2FsbGJhY2sKICBjbWRfaWQ6IDAxCiAgbW9kZTogMDEKMDA6dGVzdF9tbWlf
bWVudV9jYWxsYmFjawogIHRpdGxlOiBQQ0FNIFY0LjEKICBzdWJfdGl0bGU6IFNlbGVjdCBh
IGxhbmd1YWdlCiAgYm90dG9tOiAKICBpdGVtIDE6IEVuZ2xpc2gKICBpdGVtIDI6IEZyZW5j
aAogIGl0ZW0gMzogU3BhbmlzaAogIGl0ZW0gNDogR2VybWFuCiAgaXRlbSA1OiBSdXNzaWFu
CiAgaXRlbSA2OiBBcmFiaWMgQQogIGl0ZW0gNzogQXJhYmljIEIKICByYXdfbGVuZ3RoOiAw
CjEKMDA6dGVzdF9tbWlfbWVudV9jYWxsYmFjawogIHRpdGxlOiBQQ0FNIFY0LjEKICBzdWJf
dGl0bGU6IE1haW4gTWVudQogIGJvdHRvbTogU2VsZWN0IG9uZSBhbmQgcHJlc3MgJ09LJyB0
byBjb250aW51ZQogIGl0ZW0gMTogU21hcnRDYXJkICYgUElOCiAgaXRlbSAyOiBDQVMKICBp
dGVtIDM6IFZQOiAyMTY4MAogIGl0ZW0gNDogRG93bmxvYWQgU3RhdHVzCiAgcmF3X2xlbmd0
aDogMAoyCjAwOnRlc3RfbW1pX21lbnVfY2FsbGJhY2sKICB0aXRsZTogUENBTSBWNC4xCiAg
c3ViX3RpdGxlOiBDdXJyZW50bHkgc2VsZWN0ZWQgQ0FTOiAKICBib3R0b206IFBsZWFzZSBz
ZWxlY3QgJ1llcycgb3IgJ05vJyBhbmQgcHJlc3MgJ09LJyB0byBjb250aW51ZQogIGl0ZW0g
MTogRG8geW91IHdhbnQgdG8gY2hhbmdlIGl0PwogIGl0ZW0gMjogTm8KICBpdGVtIDM6IFll
cwogIHJhd19sZW5ndGg6IDAKMwowMDp0ZXN0X21taV9tZW51X2NhbGxiYWNrCiAgdGl0bGU6
IFBDQU0gVjQuMQogIHN1Yl90aXRsZTogQ3VycmVudGx5IHNlbGVjdGVkIENBUzoKICBib3R0
b206IFBsZWFzZSBzZWxlY3QgYW4gb3B0aW9uIGFuZCBwcmVzcyAnT0snIHRvIGNvbnRpbnVl
CiAgaXRlbSAxOiBBTEwKICBpdGVtIDI6IEVtYmVkZGVkIENoYW5uZWxzICYgUElOIFtPRkZd
CiAgaXRlbSAzOiBNT1NBSUMtUyBbT0ZGXQogIGl0ZW0gNDogTU9TQUlDLVYgW09OXQogIGl0
ZW0gNTogTU9TQUlDLUkgW09GRl0KICBpdGVtIDY6IE1PU0FJQy1CIFtPRkZdCiAgaXRlbSA3
OiBNT1NBSUMtQyBbT0ZGXQogIGl0ZW0gODogTU9TQUlDLVggW09GRl0KICBpdGVtIDk6IEtF
WUZMWSBbT0ZGXQogIHJhd19sZW5ndGg6IDAKMwowMDp0ZXN0X21taV9tZW51X2NhbGxiYWNr
CiAgdGl0bGU6IFBDQU0gVjQuMQogIHN1Yl90aXRsZTogQ3VycmVudGx5IHNlbGVjdGVkIENB
UzoKICBib3R0b206IFBsZWFzZSBzZWxlY3QgYW4gb3B0aW9uIGFuZCBwcmVzcyAnT0snIHRv
IGNvbnRpbnVlCiAgaXRlbSAxOiBBTEwKICBpdGVtIDI6IEVtYmVkZGVkIENoYW5uZWxzICYg
UElOIFtPRkZdCiAgaXRlbSAzOiBNT1NBSUMtUyBbT05dCiAgaXRlbSA0OiBNT1NBSUMtViBb
T05dCiAgaXRlbSA1OiBNT1NBSUMtSSBbT0ZGXQogIGl0ZW0gNjogTU9TQUlDLUIgW09GRl0K
ICBpdGVtIDc6IE1PU0FJQy1DIFtPRkZdCiAgaXRlbSA4OiBNT1NBSUMtWCBbT0ZGXQogIGl0
ZW0gOTogS0VZRkxZIFtPRkZdCiAgcmF3X2xlbmd0aDogMAowMDpDb25uZWN0aW9uIHRvIHJl
c291cmNlIDAwMDMwMDQxLCBzZXNzaW9uX251bWJlciAzIGNsb3NlZAowMDpQdWJsaWMgcmVz
b3VyY2UgbG9va3VwIGNhbGxiYWNrIDMgMSAxCjAwOkNBTSBjb25uZWN0aW5nIHRvIHJlc291
cmNlIDAwMDMwMDQxLCBzZXNzaW9uX251bWJlciAzCjAwOkNBTSBzdWNjZXNzZnVsbHkgY29u
bmVjdGVkIHRvIHJlc291cmNlIDAwMDMwMDQxLCBzZXNzaW9uX251bWJlciAzCjAwOnRlc3Rf
Y2FfaW5mb19jYWxsYmFjawogIFN1cHBvcnRlZCBDQSBJRDogMDEwMAogIFN1cHBvcnRlZCBD
QSBJRDogMDUwMAozCjAwOnRlc3RfbW1pX21lbnVfY2FsbGJhY2sKICB0aXRsZTogUENBTSBW
NC4xCiAgc3ViX3RpdGxlOiBDdXJyZW50bHkgc2VsZWN0ZWQgQ0FTOgogIGJvdHRvbTogUGxl
YXNlIHNlbGVjdCBhbiBvcHRpb24gYW5kIHByZXNzICdPSycgdG8gY29udGludWUKICBpdGVt
IDE6IEFMTAogIGl0ZW0gMjogRW1iZWRkZWQgQ2hhbm5lbHMgJiBQSU4gW09GRl0KICBpdGVt
IDM6IE1PU0FJQy1TIFtPRkZdCiAgaXRlbSA0OiBNT1NBSUMtViBbT05dCiAgaXRlbSA1OiBN
T1NBSUMtSSBbT0ZGXQogIGl0ZW0gNjogTU9TQUlDLUIgW09GRl0KICBpdGVtIDc6IE1PU0FJ
Qy1DIFtPRkZdCiAgaXRlbSA4OiBNT1NBSUMtWCBbT0ZGXQogIGl0ZW0gOTogS0VZRkxZIFtP
RkZdCiAgcmF3X2xlbmd0aDogMAowMDpDb25uZWN0aW9uIHRvIHJlc291cmNlIDAwMDMwMDQx
LCBzZXNzaW9uX251bWJlciAzIGNsb3NlZAowMDpQdWJsaWMgcmVzb3VyY2UgbG9va3VwIGNh
bGxiYWNrIDMgMSAxCjAwOkNBTSBjb25uZWN0aW5nIHRvIHJlc291cmNlIDAwMDMwMDQxLCBz
ZXNzaW9uX251bWJlciAzCjAwOkNBTSBzdWNjZXNzZnVsbHkgY29ubmVjdGVkIHRvIHJlc291
cmNlIDAwMDMwMDQxLCBzZXNzaW9uX251bWJlciAzCjAwOnRlc3RfY2FfaW5mb19jYWxsYmFj
awogIFN1cHBvcnRlZCBDQSBJRDogMDUwMAoK
--------------090502060609000903010007--
