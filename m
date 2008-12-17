Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <412bdbff0812162029v78e10fc5u926e52e807263981@mail.gmail.com>
Date: Tue, 16 Dec 2008 23:29:21 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840812162022g4c53d521v19a74ccf97a50ef9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_331_6245630.1229488161926"
References: <412bdbff0812161931r17fc2371mfcb28306a3acc610@mail.gmail.com>
	<37219a840812162006h33118a2fr109638bb0802603@mail.gmail.com>
	<37219a840812162022g4c53d521v19a74ccf97a50ef9@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] RFC - xc5000 init_fw option is broken for HVR-950q
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

------=_Part_331_6245630.1229488161926
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Dec 16, 2008 at 11:22 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Tue, Dec 16, 2008 at 11:06 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> Devin,
>>
>> On Tue, Dec 16, 2008 at 10:31 PM, Devin Heitmueller
>> <devin.heitmueller@gmail.com> wrote:
>>> It looks like because the reset callback is set *after* the
>>> dvb_attach(xc5000...), the if the init_fw option is set the firmware
>>> load will fail (saying "xc5000: no tuner reset callback function,
>>> fatal")
>>>
>>> We need to be setting the callback *before* the dvb_attach() to handle
>>> this case.
>>>
>>> Let me know if anybody sees anything wrong with this proposed patch,
>>> otherwise I will submit a pull request.
>>>
>>> Thanks,
>>>
>>> Devin
>>>
>>> diff -r 95d2c94ec371 linux/drivers/media/video/au0828/au0828-dvb.c
>>> --- a/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
>>> 21:35:23 2008 -0500
>>> +++ b/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
>>> 22:27:57 2008 -0500
>>> @@ -382,6 +382,9 @@
>>>
>>>        dprintk(1, "%s()\n", __func__);
>>>
>>> +       /* define general-purpose callback pointer */
>>> +       dvb->frontend->callback = au0828_tuner_callback;
>>> +
>>>        /* init frontend */
>>>        switch (dev->board) {
>>>        case AU0828_BOARD_HAUPPAUGE_HVR850:
>>> @@ -431,8 +434,6 @@
>>>                       __func__);
>>>                return -1;
>>>        }
>>> -       /* define general-purpose callback pointer */
>>> -       dvb->frontend->callback = au0828_tuner_callback;
>>>
>>>        /* register everything */
>>>
>>> --
>>> Devin J. Heitmueller
>>> http://www.devinheitmueller.com
>>> AIM: devinheitmueller
>>
>>
>> This patch is fine & correct - Thanks - Please have it merged into master.
>>
>> Acked-by: Michael Krufky <mkrufky@linuxtv.org>
>>
>
> Devin and I  (mostly Devin, actually) just realized that
> "dvb->frontend = NULL until after the demod is attached.  The line
> needs to be between the two dvb_attach() calls."
>
> So, I think we should leave the callback assignment where it is, and
> just get rid of the init_fw parameter for the xc5000 driver.
>
> I added this init_fw option in the first place, and we really dont
> need it there anymore.
>
> -Mike
>

Updated patch attached which removes the init_fw option entirely.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_331_6245630.1229488161926
Content-Type: application/octet-stream; name=xc5000_remove_init_fw
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fothh2d90
Content-Disposition: attachment; filename=xc5000_remove_init_fw

eGM1MDAwOiByZW1vdmUgaW5pdF9mdyBvcHRpb24KCkZyb206IERldmluIEhlaXRtdWVsbGVyIDxk
aGVpdG11ZWxsZXJAbGludXh0di5vcmc+CgpUaGUgaW5pdF9mdyBvcHRpb24gd2FzIGJyb2tlbiBm
b3IgdGhlIEhWUi05NTBxIGJlY2F1c2Ugd2Ugd291bGQgY2FsbCB0aGUgcmVzZXQKY2FsbGJhY2sg
aW5zaWRlIG9mIGR2Yl9hdHRhY2goKSBhbmQgdGhlIGNhbGxiYWNrIGhhZCBub3QgYmVlbiBzZXR1
cCB5ZXQuCgpNa3J1Zmt5KHdobyBhZGRlZCB0aGUgaW5pdF9mdyBmZWF0dXJlKSBzYXlzIGl0J3Mg
bm8gbG9uZ2VyIHJlcXVpcmVkLCBzbyBqdXN0CnJlbW92ZSB0aGUgb3B0aW9uIGNvbXBsZXRlbHku
CgpUaGFua3MgdG8gdXNlciBaemVpc3MgZnJvbSAjbGludXh0diBjaGF0IGZvciByZXBvcnRpbmcg
dGhlIGlzc3VlIGFuZApNaWNoYWVsIEtydWZreSA8bWtydWZreUBsaW51eHR2Lm9yZz4gZm9yIHBy
b3Bvc2luZyB0aGUgZml4LgoKUHJpb3JpdHk6IG5vcm1hbAoKU2lnbmVkLW9mZi1ieTogRGV2aW4g
SGVpdG11ZWxsZXIgPGRoZWl0bXVlbGxlckBsaW51eHR2Lm9yZz4gCgpkaWZmIC1yIDk1ZDJjOTRl
YzM3MSBsaW51eC9kcml2ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMveGM1MDAwLmMKLS0tIGEvbGlu
dXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3hjNTAwMC5jCVR1ZSBEZWMgMTYgMjE6MzU6
MjMgMjAwOCAtMDUwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMveGM1
MDAwLmMJVHVlIERlYyAxNiAyMzoyNDo0OSAyMDA4IC0wNTAwCkBAIC0zNSwxMCArMzUsNiBAQAog
c3RhdGljIGludCBkZWJ1ZzsKIG1vZHVsZV9wYXJhbShkZWJ1ZywgaW50LCAwNjQ0KTsKIE1PRFVM
RV9QQVJNX0RFU0MoZGVidWcsICJUdXJuIG9uL29mZiBkZWJ1Z2dpbmcgKGRlZmF1bHQ6b2ZmKS4i
KTsKLQotc3RhdGljIGludCB4YzUwMDBfbG9hZF9md19vbl9hdHRhY2g7Ci1tb2R1bGVfcGFyYW1f
bmFtZWQoaW5pdF9mdywgeGM1MDAwX2xvYWRfZndfb25fYXR0YWNoLCBpbnQsIDA2NDQpOwotTU9E
VUxFX1BBUk1fREVTQyhpbml0X2Z3LCAiTG9hZCBmaXJtd2FyZSBkdXJpbmcgZHJpdmVyIGluaXRp
YWxpemF0aW9uLiIpOwogCiBzdGF0aWMgREVGSU5FX01VVEVYKHhjNTAwMF9saXN0X211dGV4KTsK
IHN0YXRpYyBMSVNUX0hFQUQoaHlicmlkX3R1bmVyX2luc3RhbmNlX2xpc3QpOwpAQCAtMTAzNiw5
ICsxMDMyLDYgQEAKIAltZW1jcHkoJmZlLT5vcHMudHVuZXJfb3BzLCAmeGM1MDAwX3R1bmVyX29w
cywKIAkJc2l6ZW9mKHN0cnVjdCBkdmJfdHVuZXJfb3BzKSk7CiAKLQlpZiAoeGM1MDAwX2xvYWRf
Zndfb25fYXR0YWNoKQotCQl4YzUwMDBfaW5pdChmZSk7Ci0KIAlyZXR1cm4gZmU7CiBmYWlsOgog
CW11dGV4X3VubG9jaygmeGM1MDAwX2xpc3RfbXV0ZXgpOwo=
------=_Part_331_6245630.1229488161926
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_331_6245630.1229488161926--
