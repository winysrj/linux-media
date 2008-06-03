Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web30508.mail.mud.yahoo.com ([68.142.200.121])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ras243-dvb@yahoo.com>) id 1K3LPK-00006K-Q4
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 03:33:52 +0200
Date: Tue, 3 Jun 2008 11:32:14 +1000 (EST)
From: <ras243-dvb@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1820850413-1212456734=:41192"
Content-Transfer-Encoding: 8bit
Message-ID: <451098.41192.qm@web30508.mail.mud.yahoo.com>
Subject: [linux-dvb] DViCO Dual Digital 4 deadlock
Reply-To: ras243-dvb@yahoo.com
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

--0-1820850413-1212456734=:41192
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Hi All,

I've just tried upgrading to a recent version of the master tree so I can try
to resolve some minor reception issues I've been having with my butchered code
(which uses some possibly older xc3028 firmware) but I'm getting a deadlock (or
a race condition).  Unfortunately I can't figure out where else the usb_mutex
might be getting locked and not released but it gets stuck on a gpio reset call
during firmware loading.  Does anyone who has had their fingers in this code
have any ideas?  The tree is from yesterday (398b07fdfe79).  Output is
hopefully attached.

Thanks,
Roger.


      Get the name you always wanted with the new y7mail email address.
www.yahoo7.com.au/mail
--0-1820850413-1212456734=:41192
Content-Type: application/octet-stream; name=deadlock
Content-Transfer-Encoding: base64
Content-Description: 4240715357-deadlock
Content-Disposition: attachment; filename=deadlock

SnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IGR2Yi11c2I6IGZvdW5kIGEg
J0RWaUNPIEZ1c2lvbkhEVFYgRFZCLVQgRHVhbCBEaWdpdGFsIDQnIGluIHdh
cm0gc3RhdGUuIApKdW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogZHZiLXVz
Yjogd2lsbCBwYXNzIHRoZSBjb21wbGV0ZSBNUEVHMiB0cmFuc3BvcnQgc3Ry
ZWFtIHRvIHRoZSBzb2Z0d2FyZSBkZW11eGVyLiAKSnVuICAzIDA5OjQ5OjE5
IHB2ciBrZXJuZWw6IERWQjogcmVnaXN0ZXJpbmcgbmV3IGFkYXB0ZXIgKERW
aUNPIEZ1c2lvbkhEVFYgRFZCLVQgRHVhbCBEaWdpdGFsIDQpIApKdW4gIDMg
MDk6NDk6MTkgcHZyIGtlcm5lbDogZHZiX3JlZ2lzdGVyX2Zyb250ZW5kIApK
dW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogRFZCOiByZWdpc3RlcmluZyBm
cm9udGVuZCAwIChaYXJsaW5rIFpMMTAzNTMgRFZCLVQpLi4uIApKdW4gIDMg
MDk6NDk6MTkgcHZyIGtlcm5lbDogeGMyMDI4OiBYY3YyMDI4LzMwMjggaW5p
dCBjYWxsZWQhIApKdW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogeGMyMDI4
IDMtMDA2MTogY3JlYXRpbmcgbmV3IGluc3RhbmNlIApKdW4gIDMgMDk6NDk6
MTkgcHZyIGtlcm5lbDogeGMyMDI4IDMtMDA2MTogdHlwZSBzZXQgdG8gWENl
aXZlIHhjMjAyOC94YzMwMjggdHVuZXIgCkp1biAgMyAwOTo0OToxOSBwdnIg
a2VybmVsOiB4YzIwMjggMy0wMDYxOiB4YzIwMjhfc2V0X2NvbmZpZyBjYWxs
ZWQgCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBpbnB1dDogSVItcmVj
ZWl2ZXIgaW5zaWRlIGFuIFVTQiBEVkIgcmVjZWl2ZXIgYXMgL2NsYXNzL2lu
cHV0L2lucHV0MiAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IGR2Yi11
c2I6IHNjaGVkdWxlIHJlbW90ZSBxdWVyeSBpbnRlcnZhbCB0byAxMDAgbXNl
Y3MuIApKdW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogZHZiLXVzYjogRFZp
Q08gRnVzaW9uSERUViBEVkItVCBEdWFsIERpZ2l0YWwgNCBzdWNjZXNzZnVs
bHkgaW5pdGlhbGl6ZWQgYW5kIGNvbm5lY3RlZC4gCkp1biAgMyAwOTo0OTox
OSBwdnIga2VybmVsOiBkdmItdXNiOiBmb3VuZCBhICdEVmlDTyBGdXNpb25I
RFRWIERWQi1UIER1YWwgRGlnaXRhbCA0JyBpbiB3YXJtIHN0YXRlLiAKSnVu
ICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IGR2Yi11c2I6IHdpbGwgcGFzcyB0
aGUgY29tcGxldGUgTVBFRzIgdHJhbnNwb3J0IHN0cmVhbSB0byB0aGUgc29m
dHdhcmUgZGVtdXhlci4gCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBE
VkI6IHJlZ2lzdGVyaW5nIG5ldyBhZGFwdGVyIChEVmlDTyBGdXNpb25IRFRW
IERWQi1UIER1YWwgRGlnaXRhbCA0KSAKSnVuICAzIDA5OjQ5OjE5IHB2ciBr
ZXJuZWw6IGN4dXNiOiBObyBJUiByZWNlaXZlciBkZXRlY3RlZCBvbiB0aGlz
IGRldmljZS4gCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBkdmJfcmVn
aXN0ZXJfZnJvbnRlbmQgCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBE
VkI6IHJlZ2lzdGVyaW5nIGZyb250ZW5kIDEgKFphcmxpbmsgWkwxMDM1MyBE
VkItVCkuLi4gCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiB4YzIwMjg6
IFhjdjIwMjgvMzAyOCBpbml0IGNhbGxlZCEgCkp1biAgMyAwOTo0OToxOSBw
dnIga2VybmVsOiB4YzIwMjggNC0wMDYxOiBjcmVhdGluZyBuZXcgaW5zdGFu
Y2UgCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiB4YzIwMjggNC0wMDYx
OiB0eXBlIHNldCB0byBYQ2VpdmUgeGMyMDI4L3hjMzAyOCB0dW5lciAKSnVu
ICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IHhjMjAyOCA0LTAwNjE6IHhjMjAy
OF9zZXRfY29uZmlnIGNhbGxlZCAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJu
ZWw6IGR2Yi11c2I6IERWaUNPIEZ1c2lvbkhEVFYgRFZCLVQgRHVhbCBEaWdp
dGFsIDQgc3VjY2Vzc2Z1bGx5IGluaXRpYWxpemVkIGFuZCBjb25uZWN0ZWQu
IApKdW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogZHZiLXVzYjogZm91bmQg
YSAnRFZpQ08gRnVzaW9uSERUViBEVkItVCBEdWFsIERpZ2l0YWwgNCcgaW4g
d2FybSBzdGF0ZS4gCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBkdmIt
dXNiOiB3aWxsIHBhc3MgdGhlIGNvbXBsZXRlIE1QRUcyIHRyYW5zcG9ydCBz
dHJlYW0gdG8gdGhlIHNvZnR3YXJlIGRlbXV4ZXIuIApKdW4gIDMgMDk6NDk6
MTkgcHZyIGtlcm5lbDogRFZCOiByZWdpc3RlcmluZyBuZXcgYWRhcHRlciAo
RFZpQ08gRnVzaW9uSERUViBEVkItVCBEdWFsIERpZ2l0YWwgNCkgCkp1biAg
MyAwOTo0OToxOSBwdnIga2VybmVsOiBkdmJfcmVnaXN0ZXJfZnJvbnRlbmQg
Ckp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBEVkI6IHJlZ2lzdGVyaW5n
IGZyb250ZW5kIDIgKFphcmxpbmsgWkwxMDM1MyBEVkItVCkuLi4gCkp1biAg
MyAwOTo0OToxOSBwdnIga2VybmVsOiB4YzIwMjg6IFhjdjIwMjgvMzAyOCBp
bml0IGNhbGxlZCEgCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiB4YzIw
MjggNS0wMDYxOiBjcmVhdGluZyBuZXcgaW5zdGFuY2UgCkp1biAgMyAwOTo0
OToxOSBwdnIga2VybmVsOiB4YzIwMjggNS0wMDYxOiB0eXBlIHNldCB0byBY
Q2VpdmUgeGMyMDI4L3hjMzAyOCB0dW5lciAKSnVuICAzIDA5OjQ5OjE5IHB2
ciBrZXJuZWw6IHhjMjAyOCA1LTAwNjE6IHhjMjAyOF9zZXRfY29uZmlnIGNh
bGxlZCAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IGlucHV0OiBJUi1y
ZWNlaXZlciBpbnNpZGUgYW4gVVNCIERWQiByZWNlaXZlciBhcyAvY2xhc3Mv
aW5wdXQvaW5wdXQzIApKdW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogZHZi
LXVzYjogc2NoZWR1bGUgcmVtb3RlIHF1ZXJ5IGludGVydmFsIHRvIDEwMCBt
c2Vjcy4gCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiBkdmItdXNiOiBE
VmlDTyBGdXNpb25IRFRWIERWQi1UIER1YWwgRGlnaXRhbCA0IHN1Y2Nlc3Nm
dWxseSBpbml0aWFsaXplZCBhbmQgY29ubmVjdGVkLiAKSnVuICAzIDA5OjQ5
OjE5IHB2ciBrZXJuZWw6IGR2Yi11c2I6IGZvdW5kIGEgJ0RWaUNPIEZ1c2lv
bkhEVFYgRFZCLVQgRHVhbCBEaWdpdGFsIDQnIGluIHdhcm0gc3RhdGUuIApK
dW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogZHZiLXVzYjogd2lsbCBwYXNz
IHRoZSBjb21wbGV0ZSBNUEVHMiB0cmFuc3BvcnQgc3RyZWFtIHRvIHRoZSBz
b2Z0d2FyZSBkZW11eGVyLiAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6
IERWQjogcmVnaXN0ZXJpbmcgbmV3IGFkYXB0ZXIgKERWaUNPIEZ1c2lvbkhE
VFYgRFZCLVQgRHVhbCBEaWdpdGFsIDQpIApKdW4gIDMgMDk6NDk6MTkgcHZy
IGtlcm5lbDogY3h1c2I6IE5vIElSIHJlY2VpdmVyIGRldGVjdGVkIG9uIHRo
aXMgZGV2aWNlLiAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IGR2Yl9y
ZWdpc3Rlcl9mcm9udGVuZCAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6
IERWQjogcmVnaXN0ZXJpbmcgZnJvbnRlbmQgMyAoWmFybGluayBaTDEwMzUz
IERWQi1UKS4uLiAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IHhjMjAy
ODogWGN2MjAyOC8zMDI4IGluaXQgY2FsbGVkISAKSnVuICAzIDA5OjQ5OjE5
IHB2ciBrZXJuZWw6IHhjMjAyOCA2LTAwNjE6IGNyZWF0aW5nIG5ldyBpbnN0
YW5jZSAKSnVuICAzIDA5OjQ5OjE5IHB2ciBrZXJuZWw6IHhjMjAyOCA2LTAw
NjE6IHR5cGUgc2V0IHRvIFhDZWl2ZSB4YzIwMjgveGMzMDI4IHR1bmVyIApK
dW4gIDMgMDk6NDk6MTkgcHZyIGtlcm5lbDogeGMyMDI4IDYtMDA2MTogeGMy
MDI4X3NldF9jb25maWcgY2FsbGVkIApKdW4gIDMgMDk6NDk6MTkgcHZyIGtl
cm5lbDogZHZiLXVzYjogRFZpQ08gRnVzaW9uSERUViBEVkItVCBEdWFsIERp
Z2l0YWwgNCBzdWNjZXNzZnVsbHkgaW5pdGlhbGl6ZWQgYW5kIGNvbm5lY3Rl
ZC4gCkp1biAgMyAwOTo0OToxOSBwdnIga2VybmVsOiB1c2Jjb3JlOiByZWdp
c3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfY3h1c2IgCkp1
biAgMyAwOTo1MDozNiBwdnIga2VybmVsOiBkdmJfZnJvbnRlbmRfb3BlbiAK
SnVuICAzIDA5OjUwOjM2IHB2ciBrZXJuZWw6IGR2Yl9mcm9udGVuZF9zdGFy
dCAKSnVuICAzIDA5OjUwOjM2IHB2ciBrZXJuZWw6IGR2Yl9mcm9udGVuZF90
aHJlYWQgCkp1biAgMyAwOTo1MDozNiBwdnIga2VybmVsOiBEVkI6IGluaXRp
YWxpc2luZyBmcm9udGVuZCAwIChaYXJsaW5rIFpMMTAzNTMgRFZCLVQpLi4u
IApKdW4gIDMgMDk6NTA6MzYgcHZyIGtlcm5lbDogZHZiX2Zyb250ZW5kX2lv
Y3RsIApKdW4gIDMgMDk6NTA6MzYgcHZyIGtlcm5lbDogMDA6IDAwIDAwIDI5
IDAwIDAwIDAwIDAwIDMwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwICAKSnVu
ICAzIDA5OjUwOjM2IHB2ciBrZXJuZWw6IDEwOiAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgCkp1biAgMyAwOTo1
MDozNiBwdnIga2VybmVsOiAyMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgIApKdW4gIDMgMDk6NTA6MzYgcHZy
IGtlcm5lbDogMzA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwICAKSnVuICAzIDA5OjUwOjM2IHB2ciBrZXJuZWw6
IDQwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAgCkp1biAgMyAwOTo1MDozNiBwdnIga2VybmVsOiA1MDogMGMg
NDQgNDYgMTUgMGYgMDAgMDAgMDAgMDAgMDAgNDggMDAgNzUgMGQgMGQgMGQg
IApKdW4gIDMgMDk6NTA6MzYgcHZyIGtlcm5lbDogNjA6IDAwIDRkIDBhIDBm
IDBmIDBmIDBmIGMyIDAwIDAwIDgwIDAwIDAwIDAwIDAwIDAwICAKSnVuICAz
IDA5OjUwOjM2IHB2ciBrZXJuZWw6IDA0IDZiICAKSnVuICAzIDA5OjUwOjM2
IHB2ciBrZXJuZWw6IDcwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAxNCAgCkp1biAgMyAwOTo1MDozNiBwdnIga2Vy
bmVsOiA4MDogMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQg
MTQgMTQgMTQgMTQgIApKdW4gIDMgMDk6NTA6MzYgcHZyIGtlcm5lbDogOTA6
IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0
IDE0ICAKSnVuICAzIDA5OjUwOjM2IHB2ciBrZXJuZWw6IGEwOiAxNCAxNCAx
NCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAgCkp1
biAgMyAwOTo1MDozNiBwdnIga2VybmVsOiBiMDogMTQgMTQgMTQgMTQgMTQg
MTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgMTQgIApKdW4gIDMgMDk6
NTA6MzYgcHZyIGtlcm5lbDogYzA6IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0
IDE0IDE0IDE0IDE0IDE0IDE0IDE0IDE0ICAKSnVuICAzIDA5OjUwOjM3IHB2
ciBrZXJuZWw6IGQwOiAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAxNCAx
MCA0MCAyMCAwMyA0NiAzNCAgCkp1biAgMyAwOTo1MDozNyBwdnIga2VybmVs
OiBlMDogNDcgMWMgMDAgMDAgMDAgMzAgMDAgNDAgMTAgMDAgMDAgODAgMDAg
MDAgMDAgMDAgIApKdW4gIDMgMDk6NTA6MzcgcHZyIGtlcm5lbDogZjA6IDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
ICAKSnVuICAzIDA5OjUwOjM3IHB2ciBrZXJuZWw6IDAwOiA0NSA4NSAwMCAw
MCA2NCA0MCBlZSAzMCAwMCA1NyAzZiBmZiAwMCAwMCAwMCAyZSAgCkp1biAg
MyAwOTo1MDozNyBwdnIga2VybmVsOiAxMDogZmEgMDAgMDAgMDAgMDEgMDcg
MDAgMDggZmYgNjEgOWEgMjMgNDYgYzEgMDUgNDEgIApKdW4gIDMgMDk6NTA6
MzcgcHZyIGtlcm5lbDogMjA6IDA1IDAwIDAwIDVlIDAwIDAwIDAwIDAwIDA3
IGIwIDI1IDAxIDAyIDAwIDIyIDAwICAKSnVuICAzIDA5OjUwOjM3IHB2ciBr
ZXJuZWw6IDMwOiA1ZiA0NyAwNiAzYyA1OSAxMiAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMSAwMCAwMiAgCkp1biAgMyAwOTo1MDozNyBwdnIga2VybmVsOiA0
MDogMDAgNGYgMmIgNzcgOTcgMWYgZmYgZTAgZWIgMDEgMDAgMDAgMDAgMDAg
MDAgMDAgIApKdW4gIDMgMDk6NTA6MzcgcHZyIGtlcm5lbDogNTA6IDAzIDQ0
IDQ2IDE1IDBmIDAwIDI4IDYyIDAwIDAwIDQ4IDAwIDc1IDBkIDAwIDEzICAK
SnVuICAzIDA5OjUwOjM3IHB2ciBrZXJuZWw6IDYwOiAwMCA0ZCAwYSAwZiAz
NiA1YSBlOSBjMiAwMCAwMCA4MCAwMCAyMiAxNyA0MCA4MCAgCkp1biAgMyAw
OTo1MDozNyBwdnIga2VybmVsOiA3MDogMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MTAgMDAgMDAgMDAgMDAgMjkgMTggNDYgMTQgIApKdW4gIDMgMDk6NTA6Mzcg
cHZyIGtlcm5lbDogODA6IDE4IDA5IDY0IDUyIGYxIDAzIDNiIDAwIDIwIDIw
IDEyIDJiIDMxIDdkIDQwIDAwICAKSnVuICAzIDA5OjUwOjM3IHB2ciBrZXJu
ZWw6IDkwOiAwMCAwMCBmZiAwMCAwMCAzZiAwMCAyZiBmNSAyMSAwMCAwMCBh
MCBhNSA0MiAxNCAgCkp1biAgMyAwOTo1MDozNyBwdnIga2VybmVsOiAwMCAw
MCAwMCAgCkp1biAgMyAwOTo1MDozNyBwdnIga2VybmVsOiBhMDogNmMgMTUg
NTQgNDMgMzIgMjIgOTkgNDEgOTAgYjMgNTAgNjEgNjAgMDAgMDAgMDAgIApK
dW4gIDMgMDk6NTA6MzcgcHZyIGtlcm5lbDogYjA6IDAwIDgwIDIwIDgwIDgw
IDU1IDYyIDA3IDBhIGM4IGZmIDQ2IDI0IGEzIDAwIDE0ICAKSnVuICAzIDA5
OjUwOjM3IHB2ciBrZXJuZWw6IGMwOiA4ZCA0OCAzMCAwMCA5MyA5MyAxMCAw
MCAwMCAyOCA0NCAyNCA3MyA1NCAxNCA2MSAgCkp1biAgMyAwOTo1MDozOCBw
dnIga2VybmVsOiBkMDogMTAgMDAgMTggMDAgMjAgMDAgZmYgN2EgODAgMTQg
MTAgNDAgMjAgMDMgNDYgMzQgIApKdW4gIDMgMDk6NTA6MzggcHZyIGtlcm5l
bDogZTA6IDQ3IDFjIDAwIDAwIDAwIDMwIDAwIDQwIDEwIDAwIDAwIDgwIDAw
IDAwIDAwIDAwICAKSnVuICAzIDA5OjUwOjM4IHB2ciBrZXJuZWw6IGYwOiAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCBmZiBm
ZiAgCkp1biAgMyAwOTo1MDozOCBwdnIga2VybmVsOiBkdmJfZnJvbnRlbmRf
aW9jdGwgCkp1biAgMyAwOTo1MDozOCBwdnIga2VybmVsOiBkdmJfZnJvbnRl
bmRfYWRkX2V2ZW50IApKdW4gIDMgMDk6NTA6MzggcHZyIGtlcm5lbDogZHZi
X2Zyb250ZW5kX3N3emlnemFnX2F1dG90dW5lOiBkcmlmdDowIGludmVyc2lv
bjowIGF1dG9fc3RlcDowIGF1dG9fc3ViX3N0ZXA6MCBzdGFydGVkX2F1dG9f
c3RlcDowIApKdW4gIDMgMDk6NTA6MzggcHZyIGtlcm5lbDogemwxMDM1Mzog
emwxMDM1M19jYWxjX25vbWluYWxfcmF0ZTogYncgNywgYWRjX2Nsb2NrIDQ1
MDU2MCA9PiAweDVhZTkgCkp1biAgMyAwOTo1MDozOCBwdnIga2VybmVsOiB6
bDEwMzUzOiB6bDEwMzUzX2NhbGNfaW5wdXRfZnJlcTogaWYyIDQ1NjAwLCBp
ZmUgNDU2MDAsIGFkY19jbG9jayA0NTA1NjAgPT4gLTY2MzMgLyAweGU2MTcg
Ckp1biAgMyAwOTo1MDozOCBwdnIga2VybmVsOiB4YzIwMjggMy0wMDYxOiB4
YzIwMjhfc2V0X3BhcmFtcyBjYWxsZWQgCkp1biAgMyAwOTo1MDozOCBwdnIg
a2VybmVsOiB4YzIwMjggMy0wMDYxOiBnZW5lcmljX3NldF9mcmVxIGNhbGxl
ZCAKSnVuICAzIDA5OjUwOjM4IHB2ciBrZXJuZWw6IHhjMjAyOCAzLTAwNjE6
IHNob3VsZCBzZXQgZnJlcXVlbmN5IDE4NDUwMCBrSHogCkp1biAgMyAwOTo1
MDozOCBwdnIga2VybmVsOiB4YzIwMjggMy0wMDYxOiBjaGVja19maXJtd2Fy
ZSBjYWxsZWQgCkp1biAgMyAwOTo1MDozOCBwdnIga2VybmVsOiB4YzIwMjgg
My0wMDYxOiBsb2FkX2FsbF9maXJtd2FyZXMgY2FsbGVkIApKdW4gIDMgMDk6
NTA6MzggcHZyIGtlcm5lbDogeGMyMDI4IDMtMDA2MTogUmVhZGluZyBmaXJt
d2FyZSB4YzMwMjgtZHZpY28tYXUtMDEuZncgCkp1biAgMyAwOTo1MDozOCBw
dnIga2VybmVsOiB4YzIwMjggMy0wMDYxOiBMb2FkaW5nIDMgZmlybXdhcmUg
aW1hZ2VzIGZyb20geGMzMDI4LWR2aWNvLWF1LTAxLmZ3LCB0eXBlOiBEVmlD
TyBEdWFsRGlnNC9OYW5vMiAoQXVzdHJhbGlhKSwgdmVyIDIuNyAKSnVuICAz
IDA5OjUwOjM4IHB2ciBrZXJuZWw6IHhjMjAyOCAzLTAwNjE6IFJlYWRpbmcg
ZmlybXdhcmUgdHlwZSBEVFY3IFpBUkxJTks0NTYgU0NPREUgKDIyMDAwMDgw
KSwgaWQgMCwgc2l6ZT0yMjQuIApKdW4gIDMgMDk6NTA6MzggcHZyIGtlcm5l
bDogeGMyMDI4IDMtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEJBU0Ug
RjhNSFogKDMpLCBpZCAwLCBzaXplPTg3MTguIApKdW4gIDMgMDk6NTA6Mzgg
cHZyIGtlcm5lbDogeGMyMDI4IDMtMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0
eXBlIEQyNjIwIERUVjcgKDg4KSwgaWQgMCwgc2l6ZT0xNDkuIApKdW4gIDMg
MDk6NTA6MzggcHZyIGtlcm5lbDogeGMyMDI4IDMtMDA2MTogRmlybXdhcmUg
ZmlsZXMgbG9hZGVkLiAKSnVuICAzIDA5OjUwOjM4IHB2ciBrZXJuZWw6IHhj
MjAyOCAzLTAwNjE6IGNoZWNraW5nIGZpcm13YXJlLCB1c2VyIHJlcXVlc3Rl
ZCB0eXBlPUY4TUhaIEQyNjIwIERUVjcgKDhhKSwgaWQgMDAwMDAwMDAwMDAw
MDAwMCwgc2NvZGVfdGJsIEQyNjMzIFFBTSBEVFY3IERUVjc4IExDRCAoMTFk
MCksIHNjb2RlX25yIDAgCkp1biAgMyAwOTo1MDozOCBwdnIga2VybmVsOiBk
dmljb19ibHVlYmlyZF94YzIwMjhfY2FsbGJhY2s6IFhDMjAyOF9UVU5FUl9S
RVNFVCAwIApKdW4gIDMgMDk6NTA6MzggcHZyIGtlcm5lbDogZHZiX2Zyb250
ZW5kX2lvY3RsIApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDogQlVHOiBz
b2Z0IGxvY2t1cCAtIENQVSMxIHN0dWNrIGZvciAxMXMhIFtrZHZiLWZlLTA6
MTc0OV0gCkp1biAgMyAwOTo1MDo0OCBwdnIga2VybmVsOiAgCkp1biAgMyAw
OTo1MDo0OCBwdnIga2VybmVsOiBQaWQ6IDE3NDksIGNvbW06ICAgICAgICAg
ICAga2R2Yi1mZS0wIApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDogRUlQ
OiAwMDYwOltfX2Rvd25fZmFpbGVkX3RyeWxvY2srMTEvMTJdIENQVTogMSAK
SnVuICAzIDA5OjUwOjQ4IHB2ciBrZXJuZWw6IEVJUCBpcyBhdCBfc3Bpbl9s
b2NrKzB4Ny8weDEwIApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDogIEVG
TEFHUzogMDAwMDAyODYgICAgTm90IHRhaW50ZWQgICgyLjYuMjMuMTcgIzYp
IApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDogRUFYOiBmNWU2ZWM4NCBF
Qlg6IGY1ZTZlYzgwIEVDWDogMDAwMDAwMDMgRURYOiBmMTVlYTAwMCAKSnVu
ICAzIDA5OjUwOjQ4IHB2ciBrZXJuZWw6IEVTSTogZjdkZDIwMDAgRURJOiBm
NWU2ZWM4NCBFQlA6IGY1ZTZlNzQ0IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAw
MGQ4IApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDogQ1IwOiA4MDA1MDAz
YiBDUjI6IGI3ZjExNTMwIENSMzogMDA2NDMwMDAgQ1I0OiAwMDAwMDZkMCAK
SnVuICAzIDA5OjUwOjQ4IHB2ciBrZXJuZWw6IERSMDogMDAwMDAwMDAgRFIx
OiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERSMzogMDAwMDAwMDAgCkp1biAg
MyAwOTo1MDo0OCBwdnIga2VybmVsOiBEUjY6IGZmZmYwZmYwIERSNzogMDAw
MDA0MDAgCkp1biAgMyAwOTo1MDo0OCBwdnIga2VybmVsOiAgW3NjaGVkdWxl
X3RpbWVvdXRfdW5pbnRlcnJ1cHRpYmxlKzEwLzMyXSBfX211dGV4X2xvY2tf
aW50ZXJydXB0aWJsZV9zbG93cGF0aCsweDFhLzB4YzAgCkp1biAgMyAwOTo1
MDo0OCBwdnIga2VybmVsOiAgW3Z0X2NvbnNvbGVfcHJpbnQrMC82NzJdIHZ0
X2NvbnNvbGVfcHJpbnQrMHgwLzB4MmEwIApKdW4gIDMgMDk6NTA6NDggcHZy
IGtlcm5lbDogIFs8Zjg5ZjBjNjU+XSBkdmJfdXNiX2dlbmVyaWNfcncrMHg2
NS8weDI2MCBbZHZiX3VzYl0gCkp1biAgMyAwOTo1MDo0OCBwdnIga2VybmVs
OiAgW3JlbGVhc2VfY29uc29sZV9zZW0rNDM1LzQ2NF0gcmVsZWFzZV9jb25z
b2xlX3NlbSsweDFiMy8weDFkMCAKSnVuICAzIDA5OjUwOjQ4IHB2ciBrZXJu
ZWw6ICBbPGZhYTA4NmM4Pl0gY3h1c2JfY3RybF9tc2crMHhiOC8weGMwIFtk
dmJfdXNiX2N4dXNiXSAKSnVuICAzIDA5OjUwOjQ4IHB2ciBrZXJuZWw6ICBb
PGZhYTA4YzZhPl0gY3h1c2JfYmx1ZWJpcmRfZ3Bpb19ydysweDRhLzB4OTAg
W2R2Yl91c2JfY3h1c2JdIApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDog
IFs8ZmFhMDhkM2U+XSBjeHVzYl9ibHVlYmlyZF9ncGlvX3B1bHNlKzB4NGUv
MHg2MCBbZHZiX3VzYl9jeHVzYl0gCkp1biAgMyAwOTo1MDo0OCBwdnIga2Vy
bmVsOiAgWzxmYWEwOGYwYj5dIGR2aWNvX2JsdWViaXJkX3hjMjAyOF9jYWxs
YmFjaysweDViLzB4YjAgW2R2Yl91c2JfY3h1c2JdIApKdW4gIDMgMDk6NTA6
NDggcHZyIGtlcm5lbDogIFs8ZmFhMDI1Zjc+XSBnZW5lcmljX3NldF9mcmVx
KzB4NWQ3LzB4MWFjMCBbdHVuZXJfeGMyMDI4XSAKSnVuICAzIDA5OjUwOjQ4
IHB2ciBrZXJuZWw6ICBbPGZhYTA5MjU4Pl0gY3h1c2JfaTJjX3hmZXIrMHgy
NjgvMHgzYTAgW2R2Yl91c2JfY3h1c2JdIApKdW4gIDMgMDk6NTA6NDggcHZy
IGtlcm5lbDogIFs8ZmFhMDNmNzQ+XSB4YzIwMjhfc2V0X3BhcmFtcysweDEz
NC8weDFlMCBbdHVuZXJfeGMyMDI4XSAKSnVuICAzIDA5OjUwOjQ4IHB2ciBr
ZXJuZWw6ICBbPGY4OWI4Y2NjPl0gemwxMDM1M19zZXRfcGFyYW1ldGVycysw
eDU1Yy8weDY0MCBbemwxMDM1M10gCkp1biAgMyAwOTo1MDo0OCBwdnIga2Vy
bmVsOiAgWzxmYWExZDE5Yj5dIGR2Yl9mcm9udGVuZF9zd3ppZ3phZ19hdXRv
dHVuZSsweDEwYi8weDIwMCBbZHZiX2NvcmVdIApKdW4gIDMgMDk6NTA6NDgg
cHZyIGtlcm5lbDogIFs8ZmFhMWQ5Y2Q+XSBkdmJfZnJvbnRlbmRfc3d6aWd6
YWcrMHgyMGQvMHgyNjAgW2R2Yl9jb3JlXSAKSnVuICAzIDA5OjUwOjQ4IHB2
ciBrZXJuZWw6ICBbPGZhYTFlYmE5Pl0gZHZiX2Zyb250ZW5kX3RocmVhZCsw
eDIxOS8weDJlMCBbZHZiX2NvcmVdIApKdW4gIDMgMDk6NTA6NDggcHZyIGtl
cm5lbDogIFthdXRvcmVtb3ZlX3dha2VfZnVuY3Rpb24rMC84MF0gYXV0b3Jl
bW92ZV93YWtlX2Z1bmN0aW9uKzB4MC8weDUwIApKdW4gIDMgMDk6NTA6NDgg
cHZyIGtlcm5lbDogIFs8ZmFhMWU5OTA+XSBkdmJfZnJvbnRlbmRfdGhyZWFk
KzB4MC8weDJlMCBbZHZiX2NvcmVdIApKdW4gIDMgMDk6NTA6NDggcHZyIGtl
cm5lbDogIFtrdGhyZWFkKzY2LzExMl0ga3RocmVhZCsweDQyLzB4NzAgCkp1
biAgMyAwOTo1MDo0OCBwdnIga2VybmVsOiAgW2t0aHJlYWQrMC8xMTJdIGt0
aHJlYWQrMHgwLzB4NzAgCkp1biAgMyAwOTo1MDo0OCBwdnIga2VybmVsOiAg
W2tlcm5lbF90aHJlYWRfaGVscGVyKzcvMjRdIGtlcm5lbF90aHJlYWRfaGVs
cGVyKzB4Ny8weDE4IApKdW4gIDMgMDk6NTA6NDggcHZyIGtlcm5lbDogID09
PT09PT09PT09PT09PT09PT09PT09IApKdW4gIDMgMDk6NTA6NTggcHZyIGtl
cm5lbDogZHZiX2Zyb250ZW5kX3JlbGVhc2UgCkp1biAgMyAwOTo1MTowMCBw
dnIga2VybmVsOiBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1Y2sgZm9y
IDExcyEgW2tkdmItZmUtMDoxNzQ5XSAKSnVuICAzIDA5OjUxOjAwIHB2ciBr
ZXJuZWw6ICAKSnVuICAzIDA5OjUxOjAwIHB2ciBrZXJuZWw6IFBpZDogMTc0
OSwgY29tbTogICAgICAgICAgICBrZHZiLWZlLTAgCkp1biAgMyAwOTo1MTow
MCBwdnIga2VybmVsOiBFSVA6IDAwNjA6W19fZG93bl9mYWlsZWRfdHJ5bG9j
aysxMS8xMl0gQ1BVOiAxIApKdW4gIDMgMDk6NTE6MDAgcHZyIGtlcm5lbDog
RUlQIGlzIGF0IF9zcGluX2xvY2srMHg3LzB4MTAgCkp1biAgMyAwOTo1MTow
MCBwdnIga2VybmVsOiAgRUZMQUdTOiAwMDAwMDI4NiAgICBOb3QgdGFpbnRl
ZCAgKDIuNi4yMy4xNyAjNikgCkp1biAgMyAwOTo1MTowMCBwdnIga2VybmVs
OiBFQVg6IGY1ZTZlYzg0IEVCWDogZjVlNmVjODAgRUNYOiAwMDAwMDAwMyBF
RFg6IGYxNWVhMDAwIApKdW4gIDMgMDk6NTE6MDAgcHZyIGtlcm5lbDogRVNJ
OiBmN2RkMjAwMCBFREk6IGY1ZTZlYzg0IEVCUDogZjVlNmU3NDQgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwZDggCkp1biAgMyAwOTo1MTowMCBwdnIga2Vy
bmVsOiBDUjA6IDgwMDUwMDNiIENSMjogYjdmMTE1MzAgQ1IzOiAwMDY0MzAw
MCBDUjQ6IDAwMDAwNmQwIApKdW4gIDMgMDk6NTE6MDAgcHZyIGtlcm5lbDog
RFIwOiAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwIERSMjogMDAwMDAwMDAgRFIz
OiAwMDAwMDAwMCAKSnVuICAzIDA5OjUxOjAwIHB2ciBrZXJuZWw6IERSNjog
ZmZmZjBmZjAgRFI3OiAwMDAwMDQwMCAKSnVuICAzIDA5OjUxOjAwIHB2ciBr
ZXJuZWw6ICBbc2NoZWR1bGVfdGltZW91dF91bmludGVycnVwdGlibGUrMTAv
MzJdIF9fbXV0ZXhfbG9ja19pbnRlcnJ1cHRpYmxlX3Nsb3dwYXRoKzB4MWEv
MHhjMCAKSnVuICAzIDA5OjUxOjAwIHB2ciBrZXJuZWw6ICBbdnRfY29uc29s
ZV9wcmludCswLzY3Ml0gdnRfY29uc29sZV9wcmludCsweDAvMHgyYTAgCkp1
biAgMyAwOTo1MTowMCBwdnIga2VybmVsOiAgWzxmODlmMGM2NT5dIGR2Yl91
c2JfZ2VuZXJpY19ydysweDY1LzB4MjYwIFtkdmJfdXNiXSAKSnVuICAzIDA5
OjUxOjAwIHB2ciBrZXJuZWw6ICBbcmVsZWFzZV9jb25zb2xlX3NlbSs0MzUv
NDY0XSByZWxlYXNlX2NvbnNvbGVfc2VtKzB4MWIzLzB4MWQwIApKdW4gIDMg
MDk6NTE6MDAgcHZyIGtlcm5lbDogIFs8ZmFhMDg2Yzg+XSBjeHVzYl9jdHJs
X21zZysweGI4LzB4YzAgW2R2Yl91c2JfY3h1c2JdIApKdW4gIDMgMDk6NTE6
MDAgcHZyIGtlcm5lbDogIFs8ZmFhMDhjNmE+XSBjeHVzYl9ibHVlYmlyZF9n
cGlvX3J3KzB4NGEvMHg5MCBbZHZiX3VzYl9jeHVzYl0gCkp1biAgMyAwOTo1
MTowMCBwdnIga2VybmVsOiAgWzxmYWEwOGQzZT5dIGN4dXNiX2JsdWViaXJk
X2dwaW9fcHVsc2UrMHg0ZS8weDYwIFtkdmJfdXNiX2N4dXNiXSAKSnVuICAz
IDA5OjUxOjAwIHB2ciBrZXJuZWw6ICBbPGZhYTA4ZjBiPl0gZHZpY29fYmx1
ZWJpcmRfeGMyMDI4X2NhbGxiYWNrKzB4NWIvMHhiMCBbZHZiX3VzYl9jeHVz
Yl0gCkp1biAgMyAwOTo1MTowMCBwdnIga2VybmVsOiAgWzxmYWEwMjVmNz5d
IGdlbmVyaWNfc2V0X2ZyZXErMHg1ZDcvMHgxYWMwIFt0dW5lcl94YzIwMjhd
IApKdW4gIDMgMDk6NTE6MDAgcHZyIGtlcm5lbDogIFs8ZmFhMDkyNTg+XSBj
eHVzYl9pMmNfeGZlcisweDI2OC8weDNhMCBbZHZiX3VzYl9jeHVzYl0gCkp1
biAgMyAwOTo1MTowMCBwdnIga2VybmVsOiAgWzxmYWEwM2Y3ND5dIHhjMjAy
OF9zZXRfcGFyYW1zKzB4MTM0LzB4MWUwIFt0dW5lcl94YzIwMjhdIApKdW4g
IDMgMDk6NTE6MDAgcHZyIGtlcm5lbDogIFs8Zjg5YjhjY2M+XSB6bDEwMzUz
X3NldF9wYXJhbWV0ZXJzKzB4NTVjLzB4NjQwIFt6bDEwMzUzXSAKSnVuICAz
IDA5OjUxOjAwIHB2ciBrZXJuZWw6ICBbPGZhYTFkMTliPl0gZHZiX2Zyb250
ZW5kX3N3emlnemFnX2F1dG90dW5lKzB4MTBiLzB4MjAwIFtkdmJfY29yZV0g
Ckp1biAgMyAwOTo1MTowMCBwdnIga2VybmVsOiAgWzxmYWExZDljZD5dIGR2
Yl9mcm9udGVuZF9zd3ppZ3phZysweDIwZC8weDI2MCBbZHZiX2NvcmVdIApK
dW4gIDMgMDk6NTE6MDAgcHZyIGtlcm5lbDogIFs8ZmFhMWViYTk+XSBkdmJf
ZnJvbnRlbmRfdGhyZWFkKzB4MjE5LzB4MmUwIFtkdmJfY29yZV0gCkp1biAg
MyAwOTo1MTowMCBwdnIga2VybmVsOiAgW2F1dG9yZW1vdmVfd2FrZV9mdW5j
dGlvbiswLzgwXSBhdXRvcmVtb3ZlX3dha2VfZnVuY3Rpb24rMHgwLzB4NTAg
Ckp1biAgMyAwOTo1MTowMCBwdnIga2VybmVsOiAgWzxmYWExZTk5MD5dIGR2
Yl9mcm9udGVuZF90aHJlYWQrMHgwLzB4MmUwIFtkdmJfY29yZV0gCkp1biAg
MyAwOTo1MTowMCBwdnIga2VybmVsOiAgW2t0aHJlYWQrNjYvMTEyXSBrdGhy
ZWFkKzB4NDIvMHg3MCAKSnVuICAzIDA5OjUxOjAwIHB2ciBrZXJuZWw6ICBb
a3RocmVhZCswLzExMl0ga3RocmVhZCsweDAvMHg3MCAKSnVuICAzIDA5OjUx
OjAwIHB2ciBrZXJuZWw6ICBba2VybmVsX3RocmVhZF9oZWxwZXIrNy8yNF0g
a2VybmVsX3RocmVhZF9oZWxwZXIrMHg3LzB4MTggCkp1biAgMyAwOTo1MTow
MCBwdnIga2VybmVsOiAgPT09PT09PT09PT09PT09PT09PT09PT0gCkp1biAg
MyAwOTo1MToxMiBwdnIga2VybmVsOiBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BV
IzEgc3R1Y2sgZm9yIDExcyEgW2tkdmItZmUtMDoxNzQ5XSAKSnVuICAzIDA5
OjUxOjEyIHB2ciBrZXJuZWw6ICAKSnVuICAzIDA5OjUxOjEyIHB2ciBrZXJu
ZWw6IFBpZDogMTc0OSwgY29tbTogICAgICAgICAgICBrZHZiLWZlLTAgCkp1
biAgMyAwOTo1MToxMiBwdnIga2VybmVsOiBFSVA6IDAwNjA6W19fdXBfd2Fr
ZXVwKzIvMTJdIENQVTogMSAKSnVuICAzIDA5OjUxOjEyIHB2ciBrZXJuZWw6
IEVJUCBpcyBhdCBfc3Bpbl9sb2NrKzB4YS8weDEwIApKdW4gIDMgMDk6NTE6
MTIgcHZyIGtlcm5lbDogIEVGTEFHUzogMDAwMDAyODYgICAgTm90IHRhaW50
ZWQgICgyLjYuMjMuMTcgIzYpIApKdW4gIDMgMDk6NTE6MTIgcHZyIGtlcm5l
bDogRUFYOiBmNWU2ZWM4NCBFQlg6IGY1ZTZlYzgwIEVDWDogMDAwMDAwMDMg
RURYOiBmMTVlYTAwMCAKSnVuICAzIDA5OjUxOjEyIHB2ciBrZXJuZWw6IEVT
STogZjdkZDIwMDAgRURJOiBmNWU2ZWM4NCBFQlA6IGY1ZTZlNzQ0IERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMGQ4IApKdW4gIDMgMDk6NTE6MTIgcHZyIGtl
cm5lbDogQ1IwOiA4MDA1MDAzYiBDUjI6IGI3ZjExNTMwIENSMzogMDA2NDMw
MDAgQ1I0OiAwMDAwMDZkMCAKSnVuICAzIDA5OjUxOjEyIHB2ciBrZXJuZWw6
IERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERS
MzogMDAwMDAwMDAgCkp1biAgMyAwOTo1MToxMiBwdnIga2VybmVsOiBEUjY6
IGZmZmYwZmYwIERSNzogMDAwMDA0MDAgCkp1biAgMyAwOTo1MToxMiBwdnIg
a2VybmVsOiAgW3NjaGVkdWxlX3RpbWVvdXRfdW5pbnRlcnJ1cHRpYmxlKzEw
LzMyXSBfX211dGV4X2xvY2tfaW50ZXJydXB0aWJsZV9zbG93cGF0aCsweDFh
LzB4YzAgCkp1biAgMyAwOTo1MToxMiBwdnIga2VybmVsOiAgW3Z0X2NvbnNv
bGVfcHJpbnQrMC82NzJdIHZ0X2NvbnNvbGVfcHJpbnQrMHgwLzB4MmEwIApK
dW4gIDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFs8Zjg5ZjBjNjU+XSBkdmJf
dXNiX2dlbmVyaWNfcncrMHg2NS8weDI2MCBbZHZiX3VzYl0gCkp1biAgMyAw
OTo1MToxMiBwdnIga2VybmVsOiAgW3JlbGVhc2VfY29uc29sZV9zZW0rNDM1
LzQ2NF0gcmVsZWFzZV9jb25zb2xlX3NlbSsweDFiMy8weDFkMCAKSnVuICAz
IDA5OjUxOjEyIHB2ciBrZXJuZWw6ICBbPGZhYTA4NmM4Pl0gY3h1c2JfY3Ry
bF9tc2crMHhiOC8weGMwIFtkdmJfdXNiX2N4dXNiXSAKSnVuICAzIDA5OjUx
OjEyIHB2ciBrZXJuZWw6ICBbPGZhYTA4YzZhPl0gY3h1c2JfYmx1ZWJpcmRf
Z3Bpb19ydysweDRhLzB4OTAgW2R2Yl91c2JfY3h1c2JdIApKdW4gIDMgMDk6
NTE6MTIgcHZyIGtlcm5lbDogIFs8ZmFhMDhkM2U+XSBjeHVzYl9ibHVlYmly
ZF9ncGlvX3B1bHNlKzB4NGUvMHg2MCBbZHZiX3VzYl9jeHVzYl0gCkp1biAg
MyAwOTo1MToxMiBwdnIga2VybmVsOiAgWzxmYWEwOGYwYj5dIGR2aWNvX2Js
dWViaXJkX3hjMjAyOF9jYWxsYmFjaysweDViLzB4YjAgW2R2Yl91c2JfY3h1
c2JdIApKdW4gIDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFs8ZmFhMDI1Zjc+
XSBnZW5lcmljX3NldF9mcmVxKzB4NWQ3LzB4MWFjMCBbdHVuZXJfeGMyMDI4
XSAKSnVuICAzIDA5OjUxOjEyIHB2ciBrZXJuZWw6ICBbPGZhYTA5MjU4Pl0g
Y3h1c2JfaTJjX3hmZXIrMHgyNjgvMHgzYTAgW2R2Yl91c2JfY3h1c2JdIApK
dW4gIDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFs8ZmFhMDNmNzQ+XSB4YzIw
Mjhfc2V0X3BhcmFtcysweDEzNC8weDFlMCBbdHVuZXJfeGMyMDI4XSAKSnVu
ICAzIDA5OjUxOjEyIHB2ciBrZXJuZWw6ICBbPGY4OWI4Y2NjPl0gemwxMDM1
M19zZXRfcGFyYW1ldGVycysweDU1Yy8weDY0MCBbemwxMDM1M10gCkp1biAg
MyAwOTo1MToxMiBwdnIga2VybmVsOiAgWzxmYWExZDE5Yj5dIGR2Yl9mcm9u
dGVuZF9zd3ppZ3phZ19hdXRvdHVuZSsweDEwYi8weDIwMCBbZHZiX2NvcmVd
IApKdW4gIDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFs8ZmFhMWQ5Y2Q+XSBk
dmJfZnJvbnRlbmRfc3d6aWd6YWcrMHgyMGQvMHgyNjAgW2R2Yl9jb3JlXSAK
SnVuICAzIDA5OjUxOjEyIHB2ciBrZXJuZWw6ICBbPGZhYTFlYmE5Pl0gZHZi
X2Zyb250ZW5kX3RocmVhZCsweDIxOS8weDJlMCBbZHZiX2NvcmVdIApKdW4g
IDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFthdXRvcmVtb3ZlX3dha2VfZnVu
Y3Rpb24rMC84MF0gYXV0b3JlbW92ZV93YWtlX2Z1bmN0aW9uKzB4MC8weDUw
IApKdW4gIDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFs8ZmFhMWU5OTA+XSBk
dmJfZnJvbnRlbmRfdGhyZWFkKzB4MC8weDJlMCBbZHZiX2NvcmVdIApKdW4g
IDMgMDk6NTE6MTIgcHZyIGtlcm5lbDogIFtrdGhyZWFkKzY2LzExMl0ga3Ro
cmVhZCsweDQyLzB4NzAgCkp1biAgMyAwOTo1MToxMiBwdnIga2VybmVsOiAg
W2t0aHJlYWQrMC8xMTJdIGt0aHJlYWQrMHgwLzB4NzAgCkp1biAgMyAwOTo1
MToxMiBwdnIga2VybmVsOiAgW2tlcm5lbF90aHJlYWRfaGVscGVyKzcvMjRd
IGtlcm5lbF90aHJlYWRfaGVscGVyKzB4Ny8weDE4IApKdW4gIDMgMDk6NTE6
MTIgcHZyIGtlcm5lbDogID09PT09PT09PT09PT09PT09PT09PT09Cg==

--0-1820850413-1212456734=:41192
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0-1820850413-1212456734=:41192--
