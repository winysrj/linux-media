Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:44033 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbZLHGC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 01:02:58 -0500
Message-ID: <36364.64.213.30.2.1260252173.squirrel@webmail.exetel.com.au>
In-Reply-To: <829197380912020657v52e42690k46172f047ebd24b0@mail.gmail.com>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
    <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
    <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
    <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
    <46566.64.213.30.2.1259278557.squirrel@webmail.exetel.com.au>
    <702870ef0912010118r1e5e3been840726e6364d991a@mail.gmail.com>
    <829197380912020657v52e42690k46172f047ebd24b0@mail.gmail.com>
Date: Tue, 8 Dec 2009 17:02:53 +1100 (EST)
Subject: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning
     regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: mchehab@redhat.com
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	terrywu2009@gmail.com, awalls@radix.net,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20091208170253_10240"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_20091208170253_10240
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> On Tue, Dec 1, 2009 at 4:18 AM, Vincent McIntyre
> <vincent.mcintyre@gmail.com> wrote:
>> Hi Rob
>>
>> I missed your followup and tested the 'revert.diff' patch, attached
>> for reference.
>> I have been slow replying because I've been scratching my head over the
>> results.
>>
>> I used 'signaltest.pl' to test[1], which uses tzap under the hood.
>> Perhaps this is not the best choice, but I wanted something that I
>> thought would
>> allow objective comparisons. That's trickier than I thought...
>> Unfortunately I only discovered last night how easy 'vlc
>> ./channels.conf' makes doing quick visual checks. I didn't have enough
>> time to re-patch and test again.
>>
>> My test procedure was:
>>  - get a baseline with tzap and signaltest.pl
>>  - patch, make, install. cold boot.
>>  - test with tzap and signaltest.pl
>>  - revert patch, for the moment.
>>
>> I tested two kernels, and both cards. I tested all the tuners but I'll
>> spare you that for now.
>>
>>  * 2.6.24-23-rt + v4l (c57f47cfb0e8+ tip)
>>
>>   I got rather different baseline results. All channels had
>> significantly higher BER
>>   than I'd noticed before. After patching, snr on some channels
>> seemed a little higher
>>   and BER was lower. On ch9, I think snr was up and BER improved a
>> little.
>>
>>  here are the signaltest summary tables:
>>  without patch. usb device (dvb0) usbid db78:0fe9
>>  Frequency       Signal          Ber             Unc
>>  =========       ========        ========        ========
>>  177500000         76.0 %           322.6           672.4  Seven
>>  191625000         76.0 %           320.2          1783.3  Nine
>>  219500000         76.8 %           329.8          2948.2  Ten
>>  226500000         76.9 %           296.6          4885.0  ABC
>>  571500000         77.0 %           542.0          7529.4  SBS
>>  578500000         77.1 %           539.5         10669.7  D44
>>
>>  with patch. usb device (dvb0) usbid db78:0fe9
>>  Frequency       Signal          Ber             Unc
>>  =========       ========        ========        ========
>>  177500000         76.6 %             2.3             0.0
>>  191625000         77.0 %           235.5            83.3
>>  219500000         76.9 %           288.0           501.8
>>  226500000         76.9 %           295.1          1416.4
>>  571500000         77.0 %           523.4          3980.0
>>  578500000         77.1 %           549.9          7409.4
>>
>>  without patch. pcie device (dvb1) pciid db78:18ac
>>  Frequency       Signal          Ber             Unc
>>  =========       ========        ========        ========
>>  177500000         71.2 %             3.1             0.0
>>  191625000         21.7 %           645.4           246.4
>>  219500000         73.6 %             1.9          1632.0
>>  226500000         73.5 %             2.8          1632.0
>>  571500000         73.9 %            13.6          2134.6
>>  578500000         72.7 %            58.2          6393.4
>>
>>  with patch. pcie device (dvb1) pciid db78:18ac
>>  Frequency       Signal          Ber             Unc
>>  =========       ========        ========        ========
>>  177500000         73.2 %             4.0             0.0
>>  191625000         74.0 %            37.0             0.0
>>  219500000         73.9 %             0.0             0.0
>>  226500000         73.0 %             4.6             0.0
>>  571500000         74.2 %            76.7           193.6
>>  578500000         72.8 %           213.8          4480.3
>>
>>
>>  * 2.6.31-14-generic + v4l (19c0469c02c3+ tip)
>>  Hard to say if I'm seeing an improvement.
>>
>> before patching - adapter0 usbid db78:0fe9
>> Frequency       Signal          Ber             Unc
>> =========       ========        ========        ========
>> 177500000         75.5 %           293.7          1926.4
>> 191625000         75.9 %           363.2          2993.3
>> 219500000         76.7 %           304.5          4225.8
>> 226500000         76.9 %           223.8          6153.3
>> 571500000         77.0 %           491.7          8726.0
>> 578500000         77.1 %           558.9         11787.1
>>
>> adapter0 repeat usbid db78:0fe9 (not sure what happened to UNC here..)
>> Frequency       Signal          Ber             Unc
>> =========       ========        ========        ========
>> 177500000         75.9 %           327.9         13893.6
>> 191625000         76.0 %           392.8         14939.0
>> 219500000         76.7 %           252.0         16052.0
>> 226500000         76.8 %           254.0         18063.1
>> 571500000         76.9 %           533.2         20644.1
>> 578500000         76.9 %           464.1         23836.8
>>
>> after patching - adapter0 usbid db78:0fe9
>> Frequency       Signal          Ber             Unc
>> =========       ========        ========        ========
>> 177500000         76.3 %             2.5             0.0
>> 191625000         76.8 %           227.6           119.0
>> 219500000         76.8 %           262.6           604.5
>> 226500000         76.8 %           282.7          1545.4
>> 571500000         77.0 %           486.8          3541.7
>> 578500000         77.1 %           521.5          6537.7
>>
>>
>> before patching - adapter1 pciid db78:18ac
>> Frequency       Signal          Ber             Unc
>> =========       ========        ========        ========
>> 177500000         70.9 %             0.0             0.0
>> 191625000         69.8 %             2.7             0.0
>> 219500000         73.2 %             4.1             0.0
>> 226500000         73.4 %             4.5             0.0
>> 571500000         74.0 %             0.0             0.0
>> 578500000         72.3 %           125.7          3589.3
>>
>> after patching - adapter2 pciid  db78:18ac  (enumeration order changed)
>> Frequency       Signal          Ber             Unc
>> =========       ========        ========        ========
>> 177500000         73.6 %             0.6             0.0
>> 191625000         74.2 %             0.0             0.0
>> 219500000         74.0 %             4.9             0.0
>> 226500000         73.3 %           163.2           349.7
>> 571500000         74.4 %           267.0          1014.6
>> 578500000         72.7 %            70.7          4906.0
>
> The stats above suggest that reverting the patch in question
> significantly reduces the instances of uncorrectable errors.
>
> It looks like indeed that a regression was introduced.
>
> Mauro, any thoughts on this?  I had heard things from a couple of
> other zl10353/xc3028 users that the tuning performance was pretty
> crappy compared to the mrec xc3028 driver.  This could definitely be
> the cause.

Mauro,

Resend of my proposed patch attached that reverts tuning regressions with
my DViCO card, whilst still fixing the original 6Mhz tuning issue.  Please
merge or let me know how else I should proceed to get this merged.

Thanks

-Rob

>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

------=_20091208170253_10240
Content-Type: application/octet-stream; name="revert2.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="revert2.diff"

ZGlmZiAtciAzMmIyYTE4NzU3NTIgbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1
bmVyLXhjMjAyOC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5l
ci14YzIwMjguYwlGcmkgTm92IDIwIDEyOjQ3OjQwIDIwMDkgKzAxMDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1bmVyLXhjMjAyOC5jCUZyaSBOb3YgMjcgMTA6Mjk6
MjIgMjAwOSArMTEwMApAQCAtOTM0LDI5ICs5MzQsMjMgQEAKIAkgKiB0aGF0IHhjMjAyOCB3aWxs
IGJlIGluIGEgc2FmZSBzdGF0ZS4KIAkgKiBNYXliZSB0aGlzIG1pZ2h0IGFsc28gYmUgbmVlZGVk
IGZvciBEVFYuCiAJICovCi0JaWYgKG5ld19tb2RlID09IFRfQU5BTE9HX1RWKQorCWlmIChuZXdf
bW9kZSA9PSBUX0FOQUxPR19UVikgewogCQlyYyA9IHNlbmRfc2VxKHByaXYsIHsweDAwLCAweDAw
fSk7Ci0KLQkvKgotCSAqIERpZ2l0YWwgbW9kZXMgcmVxdWlyZSBhbiBvZmZzZXQgdG8gYWRqdXN0
IHRvIHRoZQotCSAqIHByb3BlciBmcmVxdWVuY3kuCi0JICogQW5hbG9nIG1vZGVzIHJlcXVpcmUg
b2Zmc2V0ID0gMAotCSAqLwotCWlmIChuZXdfbW9kZSA9PSBUX0RJR0lUQUxfVFYpIHsKLQkJLyog
U2V0cyB0aGUgb2Zmc2V0IGFjY29yZGluZyB3aXRoIGZpcm13YXJlICovCi0JCWlmIChwcml2LT5j
dXJfZncudHlwZSAmIERUVjYpCi0JCQlvZmZzZXQgPSAxNzUwMDAwOwotCQllbHNlIGlmIChwcml2
LT5jdXJfZncudHlwZSAmIERUVjcpCi0JCQlvZmZzZXQgPSAyMjUwMDAwOwotCQllbHNlCS8qIERU
Vjggb3IgRFRWNzggKi8KLQkJCW9mZnNldCA9IDI3NTAwMDA7Ci0KKwl9IGVsc2UgaWYgKHByaXYt
PmN1cl9mdy50eXBlICYgRFRWNikgeworCQlvZmZzZXQgPSAxNzUwMDAwOworCX0gZWxzZSB7CisJ
CW9mZnNldCA9IDI3NTAwMDA7CisJCiAJCS8qCi0JCSAqIFdlIG11c3QgYWRqdXN0IHRoZSBvZmZz
ZXQgYnkgNTAwa0h6ICB3aGVuCi0JCSAqIHR1bmluZyBhIDdNSHogVkhGIGNoYW5uZWwgd2l0aCBE
VFY3OCBmaXJtd2FyZQotCQkgKiAodXNlZCBpbiBBdXN0cmFsaWEsIEl0YWx5IGFuZCBHZXJtYW55
KQorCQkgKiBXZSBtdXN0IGFkanVzdCB0aGUgb2Zmc2V0IGJ5IDUwMGtIeiBpbiB0d28gY2FzZXMg
aW4gb3JkZXIKKwkJICogdG8gY29ycmVjdGx5IGNlbnRlciB0aGUgSUYgb3V0cHV0OgorCQkgKiAx
KSBXaGVuIHRoZSBaQVJMSU5LNDU2IG9yIERJQkNPTTUyIHRhYmxlcyB3ZXJlIGV4cGxpY2l0bHkK
KwkJICogICAgc2VsZWN0ZWQgYW5kIGEgN01IeiBjaGFubmVsIGlzIHR1bmVkOworCQkgKiAyKSBX
aGVuIHR1bmluZyBhIFZIRiBjaGFubmVsIHdpdGggRFRWNzggZmlybXdhcmUuCiAJCSAqLwotCQlp
ZiAoKHByaXYtPmN1cl9mdy50eXBlICYgRFRWNzgpICYmIGZyZXEgPCA0NzAwMDAwMDApCisJCWlm
ICgoKHByaXYtPmN1cl9mdy50eXBlICYgRFRWNykgJiYKKwkJICAgICAocHJpdi0+Y3VyX2Z3LnNj
b2RlX3RhYmxlICYgKFpBUkxJTks0NTYgfCBESUJDT001MikpKSB8fAorCQkgICAgKChwcml2LT5j
dXJfZncudHlwZSAmIERUVjc4KSAmJiBmcmVxIDwgNDcwMDAwMDAwKSkKIAkJCW9mZnNldCAtPSA1
MDAwMDA7CiAJfQogCkBAIC0xMTE0LDE5ICsxMTA4LDggQEAKIAl9CiAKIAkvKiBBbGwgUy1jb2Rl
IHRhYmxlcyBuZWVkIGEgMjAwa0h6IHNoaWZ0ICovCi0JaWYgKHByaXYtPmN0cmwuZGVtb2QpIHsK
KwlpZiAocHJpdi0+Y3RybC5kZW1vZCkKIAkJZGVtb2QgPSBwcml2LT5jdHJsLmRlbW9kICsgMjAw
OwotCQkvKgotCQkgKiBUaGUgRFRWNyBTLWNvZGUgdGFibGUgbmVlZHMgYSA3MDAga0h6IHNoaWZ0
LgotCQkgKiBUaGFua3MgdG8gVGVycnkgV3UgPHRlcnJ5d3UyMDA5QGdtYWlsLmNvbT4gZm9yIHJl
cG9ydGluZyB0aGlzCi0JCSAqCi0JCSAqIERUVjcgaXMgb25seSB1c2VkIGluIEF1c3RyYWxpYS4g
IEdlcm1hbnkgb3IgSXRhbHkgbWF5IGFsc28KLQkJICogdXNlIHRoaXMgZmlybXdhcmUgYWZ0ZXIg
aW5pdGlhbGl6YXRpb24sIGJ1dCBhIHR1bmUgdG8gYSBVSEYKLQkJICogY2hhbm5lbCBzaG91bGQg
dGhlbiBjYXVzZSBEVFY3OCB0byBiZSB1c2VkLgotCQkgKi8KLQkJaWYgKHR5cGUgJiBEVFY3KQot
CQkJZGVtb2QgKz0gNTAwOwotCX0KIAogCXJldHVybiBnZW5lcmljX3NldF9mcmVxKGZlLCBwLT5m
cmVxdWVuY3ksCiAJCQkJVF9ESUdJVEFMX1RWLCB0eXBlLCAwLCBkZW1vZCk7Cg==
------=_20091208170253_10240--


