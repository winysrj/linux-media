Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAS7vqBu019930
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 02:57:52 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAS7verw005908
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 02:57:40 -0500
Received: by rv-out-0506.google.com with SMTP id f6so1414468rvb.51
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 23:57:40 -0800 (PST)
Message-ID: <f17812d70811272357t5fb043e3oee6bd9a269f4efaa@mail.gmail.com>
Date: Fri, 28 Nov 2008 15:57:40 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <f17812d70811272356iddc5207rb2bb99cc7c88dcac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_43721_12946444.1227859060206"
References: <f17812d70811271731s1473f23cn81ca782172acc1cd@mail.gmail.com>
	<Pine.LNX.4.64.0811280807120.3990@axis700.grange>
	<f17812d70811272356iddc5207rb2bb99cc7c88dcac@mail.gmail.com>
Cc: video4linux-list@redhat.com,
	ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped IO access
	for camera (QCI) registers
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

------=_Part_43721_12946444.1227859060206
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, V4L ML forgot to be CC'ed.


---------- Forwarded message ----------
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, Nov 28, 2008 at 3:56 PM
Subject: Re: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped IO
access for camera (QCI) registers
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>


Stumped, due to corporate rule I have to use gmail through its
web interface. So I'll have to attach the patch regarding the line
wrapping issue with the space issue you mentioned fixed.

You added your SOB several months ago when you modified
my initial patch, so I keep it untouched.

And again, I'm OK if you can do a trivial merge and I expect
the final patch will be a bit different than this one.

Thanks.

On Fri, Nov 28, 2008 at 3:18 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 28 Nov 2008, Eric Miao wrote:
>
>> >From d1c6773db6841bea6ead5567ba71098c88d89aff Mon Sep 17 00:00:00 2001
>> From: Eric Miao <eric.miao@marvell.com>
>> Date: Fri, 28 Nov 2008 09:29:56 +0800
>> Subject: [PATCH] V4L/DVB: pxa-camera: use memory mapped IO access for
>> camera (QCI) registers
>>
>> Signed-off-by: Eric Miao <eric.miao@marvell.com>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> Eric, thanks for splitting the patch, but:
>
> 1. I didn't sing-off under this one. Not yet. You probably meant "Cc:"
>
> 2. I cannot sign-off under it in _this_ form - your mailer _again_ wrapped
> lines like this one:
>
>> @@ -507,6 +609,7 @@ static void pxa_camera_dma_irq(int channel, struct
>> pxa_camera_dev *pcdev,
>
>
> and removed spaces in the beginning of unchanged empty lines, like this
> one:
>
>> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
>> index 9f1038f..9246306 100644
>> --- a/drivers/media/video/pxa_camera.c
>> +++ b/drivers/media/video/pxa_camera.c
>> @@ -39,11 +39,104 @@
>>  #include <mach/pxa-regs.h>
>>  #include <mach/camera.h>
>>
>
> ^^^^^^
>
> 3. Please, cc video4linux patches like this one to the video4linux list I
> mentioned in my previous mail:
>
> video4linux-list@redhat.com
>
> 4. You also merge the pxa_camera.h header into the .c file, please reflect
> this in the comment.
>
> 5. As I told you, pxa-camera is undergoing some changes at the moment, so,
> this patch will probably not apply in its present form. If you don't mind
> and if the merge is trivial, which it should be, I can do it myself, just
> so you don't wonder why the committed version of your patch differs from
> what you submit.
>
> Looking forward to a non-corrupted and properly formatted, commented and
> cc-ed version of this patch.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>



-- 
Cheers
- eric

------=_Part_43721_12946444.1227859060206
Content-Type: text/x-diff;
	name=0002-V4L-DVB-pxa-camera-use-memory-mapped-IO-access-for.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fo2jjj0b0
Content-Disposition: attachment;
	filename=0002-V4L-DVB-pxa-camera-use-memory-mapped-IO-access-for.patch

RnJvbSBkMWM2NzczZGI2ODQxYmVhNmVhZDU1NjdiYTcxMDk4Yzg4ZDg5YWZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogRnJpLCAyOCBOb3YgMjAwOCAwOToyOTo1NiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIFY0TC9E
VkI6IHB4YS1jYW1lcmE6IHVzZSBtZW1vcnkgbWFwcGVkIElPIGFjY2VzcyBmb3IgY2FtZXJhIChR
Q0kpIHJlZ2lzdGVycwoKU2lnbmVkLW9mZi1ieTogRXJpYyBNaWFvIDxlcmljLm1pYW9AbWFydmVs
bC5jb20+ClNpZ25lZC1vZmYtYnk6IEd1ZW5uYWRpIExpYWtob3ZldHNraSA8Zy5saWFraG92ZXRz
a2lAZ214LmRlPgotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vcHhhX2NhbWVyYS5jIHwgIDIwNCAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQogZHJpdmVycy9tZWRpYS92aWRl
by9weGFfY2FtZXJhLmggfCAgIDk1IC0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2Vk
LCAxNjIgaW5zZXJ0aW9ucygrKSwgMTM3IGRlbGV0aW9ucygtKQogZGVsZXRlIG1vZGUgMTAwNjQ0
IGRyaXZlcnMvbWVkaWEvdmlkZW8vcHhhX2NhbWVyYS5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZWRpYS92aWRlby9weGFfY2FtZXJhLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3B4YV9jYW1lcmEu
YwppbmRleCA5ZjEwMzhmLi45MjQ2MzA2IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVv
L3B4YV9jYW1lcmEuYworKysgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3B4YV9jYW1lcmEuYwpAQCAt
MzksMTEgKzM5LDEwNCBAQAogI2luY2x1ZGUgPG1hY2gvcHhhLXJlZ3MuaD4KICNpbmNsdWRlIDxt
YWNoL2NhbWVyYS5oPgoKLSNpbmNsdWRlICJweGFfY2FtZXJhLmgiCi0KICNkZWZpbmUgUFhBX0NB
TV9WRVJTSU9OX0NPREUgS0VSTkVMX1ZFUlNJT04oMCwgMCwgNSkKICNkZWZpbmUgUFhBX0NBTV9E
UlZfTkFNRSAicHhhMjd4LWNhbWVyYSIKIAorLyogQ2FtZXJhIEludGVyZmFjZSAqLworI2RlZmlu
ZSBDSUNSMAkJKDB4MDAwMCkKKyNkZWZpbmUgQ0lDUjEJCSgweDAwMDQpCisjZGVmaW5lIENJQ1Iy
CQkoMHgwMDA4KQorI2RlZmluZSBDSUNSMwkJKDB4MDAwQykKKyNkZWZpbmUgQ0lDUjQJCSgweDAw
MTApCisjZGVmaW5lIENJU1IJCSgweDAwMTQpCisjZGVmaW5lIENJRlIJCSgweDAwMTgpCisjZGVm
aW5lIENJVE9SCQkoMHgwMDFDKQorI2RlZmluZSBDSUJSMAkJKDB4MDAyOCkKKyNkZWZpbmUgQ0lC
UjEJCSgweDAwMzApCisjZGVmaW5lIENJQlIyCQkoMHgwMDM4KQorCisjZGVmaW5lIENJQ1IwX0RN
QUVOCSgxIDw8IDMxKQkvKiBETUEgcmVxdWVzdCBlbmFibGUgKi8KKyNkZWZpbmUgQ0lDUjBfUEFS
X0VOCSgxIDw8IDMwKQkvKiBQYXJpdHkgZW5hYmxlICovCisjZGVmaW5lIENJQ1IwX1NMX0NBUF9F
TgkoMSA8PCAyOSkJLyogQ2FwdHVyZSBlbmFibGUgZm9yIHNsYXZlIG1vZGUgKi8KKyNkZWZpbmUg
Q0lDUjBfRU5CCSgxIDw8IDI4KQkvKiBDYW1lcmEgaW50ZXJmYWNlIGVuYWJsZSAqLworI2RlZmlu
ZSBDSUNSMF9ESVMJKDEgPDwgMjcpCS8qIENhbWVyYSBpbnRlcmZhY2UgZGlzYWJsZSAqLworI2Rl
ZmluZSBDSUNSMF9TSU0JKDB4NyA8PCAyNCkJLyogU2Vuc29yIGludGVyZmFjZSBtb2RlIG1hc2sg
Ki8KKyNkZWZpbmUgQ0lDUjBfVE9NCSgxIDw8IDkpCS8qIFRpbWUtb3V0IG1hc2sgKi8KKyNkZWZp
bmUgQ0lDUjBfUkRBVk0JKDEgPDwgOCkJLyogUmVjZWl2ZS1kYXRhLWF2YWlsYWJsZSBtYXNrICov
CisjZGVmaW5lIENJQ1IwX0ZFTQkoMSA8PCA3KQkvKiBGSUZPLWVtcHR5IG1hc2sgKi8KKyNkZWZp
bmUgQ0lDUjBfRU9MTQkoMSA8PCA2KQkvKiBFbmQtb2YtbGluZSBtYXNrICovCisjZGVmaW5lIENJ
Q1IwX1BFUlJNCSgxIDw8IDUpCS8qIFBhcml0eS1lcnJvciBtYXNrICovCisjZGVmaW5lIENJQ1Iw
X1FETQkoMSA8PCA0KQkvKiBRdWljay1kaXNhYmxlIG1hc2sgKi8KKyNkZWZpbmUgQ0lDUjBfQ0RN
CSgxIDw8IDMpCS8qIERpc2FibGUtZG9uZSBtYXNrICovCisjZGVmaW5lIENJQ1IwX1NPRk0JKDEg
PDwgMikJLyogU3RhcnQtb2YtZnJhbWUgbWFzayAqLworI2RlZmluZSBDSUNSMF9FT0ZNCSgxIDw8
IDEpCS8qIEVuZC1vZi1mcmFtZSBtYXNrICovCisjZGVmaW5lIENJQ1IwX0ZPTQkoMSA8PCAwKQkv
KiBGSUZPLW92ZXJydW4gbWFzayAqLworCisjZGVmaW5lIENJQ1IxX1RCSVQJKDEgPDwgMzEpCS8q
IFRyYW5zcGFyZW5jeSBiaXQgKi8KKyNkZWZpbmUgQ0lDUjFfUkdCVF9DT05WCSgweDMgPDwgMjkp
CS8qIFJHQlQgY29udmVyc2lvbiBtYXNrICovCisjZGVmaW5lIENJQ1IxX1BQTAkoMHg3ZmYgPDwg
MTUpCS8qIFBpeGVscyBwZXIgbGluZSBtYXNrICovCisjZGVmaW5lIENJQ1IxX1JHQl9DT05WCSgw
eDcgPDwgMTIpCS8qIFJHQiBjb252ZXJzaW9uIG1hc2sgKi8KKyNkZWZpbmUgQ0lDUjFfUkdCX0YJ
KDEgPDwgMTEpCS8qIFJHQiBmb3JtYXQgKi8KKyNkZWZpbmUgQ0lDUjFfWUNCQ1JfRgkoMSA8PCAx
MCkJLyogWUNiQ3IgZm9ybWF0ICovCisjZGVmaW5lIENJQ1IxX1JHQl9CUFAJKDB4NyA8PCA3KQkv
KiBSR0IgYmlzIHBlciBwaXhlbCBtYXNrICovCisjZGVmaW5lIENJQ1IxX1JBV19CUFAJKDB4MyA8
PCA1KQkvKiBSYXcgYmlzIHBlciBwaXhlbCBtYXNrICovCisjZGVmaW5lIENJQ1IxX0NPTE9SX1NQ
CSgweDMgPDwgMykJLyogQ29sb3Igc3BhY2UgbWFzayAqLworI2RlZmluZSBDSUNSMV9EVwkoMHg3
IDw8IDApCS8qIERhdGEgd2lkdGggbWFzayAqLworCisjZGVmaW5lIENJQ1IyX0JMVwkoMHhmZiA8
PCAyNCkJLyogQmVnaW5uaW5nLW9mLWxpbmUgcGl4ZWwgY2xvY2sKKwkJCQkJICAgd2FpdCBjb3Vu
dCBtYXNrICovCisjZGVmaW5lIENJQ1IyX0VMVwkoMHhmZiA8PCAxNikJLyogRW5kLW9mLWxpbmUg
cGl4ZWwgY2xvY2sKKwkJCQkJICAgd2FpdCBjb3VudCBtYXNrICovCisjZGVmaW5lIENJQ1IyX0hT
VwkoMHgzZiA8PCAxMCkJLyogSG9yaXpvbnRhbCBzeW5jIHB1bHNlIHdpZHRoIG1hc2sgKi8KKyNk
ZWZpbmUgQ0lDUjJfQkZQVwkoMHgzZiA8PCAzKQkvKiBCZWdpbm5pbmctb2YtZnJhbWUgcGl4ZWwg
Y2xvY2sKKwkJCQkJICAgd2FpdCBjb3VudCBtYXNrICovCisjZGVmaW5lIENJQ1IyX0ZTVwkoMHg3
IDw8IDApCS8qIEZyYW1lIHN0YWJpbGl6YXRpb24KKwkJCQkJICAgd2FpdCBjb3VudCBtYXNrICov
CisKKyNkZWZpbmUgQ0lDUjNfQkZXCSgweGZmIDw8IDI0KQkvKiBCZWdpbm5pbmctb2YtZnJhbWUg
bGluZSBjbG9jaworCQkJCQkgICB3YWl0IGNvdW50IG1hc2sgKi8KKyNkZWZpbmUgQ0lDUjNfRUZX
CSgweGZmIDw8IDE2KQkvKiBFbmQtb2YtZnJhbWUgbGluZSBjbG9jaworCQkJCQkgICB3YWl0IGNv
dW50IG1hc2sgKi8KKyNkZWZpbmUgQ0lDUjNfVlNXCSgweDNmIDw8IDEwKQkvKiBWZXJ0aWNhbCBz
eW5jIHB1bHNlIHdpZHRoIG1hc2sgKi8KKyNkZWZpbmUgQ0lDUjNfQkZQVwkoMHgzZiA8PCAzKQkv
KiBCZWdpbm5pbmctb2YtZnJhbWUgcGl4ZWwgY2xvY2sKKwkJCQkJICAgd2FpdCBjb3VudCBtYXNr
ICovCisjZGVmaW5lIENJQ1IzX0xQRgkoMHg3ZmYgPDwgMCkJLyogTGluZXMgcGVyIGZyYW1lIG1h
c2sgKi8KKworI2RlZmluZSBDSUNSNF9NQ0xLX0RMWQkoMHgzIDw8IDI0KQkvKiBNQ0xLIERhdGEg
Q2FwdHVyZSBEZWxheSBtYXNrICovCisjZGVmaW5lIENJQ1I0X1BDTEtfRU4JKDEgPDwgMjMpCS8q
IFBpeGVsIGNsb2NrIGVuYWJsZSAqLworI2RlZmluZSBDSUNSNF9QQ1AJKDEgPDwgMjIpCS8qIFBp
eGVsIGNsb2NrIHBvbGFyaXR5ICovCisjZGVmaW5lIENJQ1I0X0hTUAkoMSA8PCAyMSkJLyogSG9y
aXpvbnRhbCBzeW5jIHBvbGFyaXR5ICovCisjZGVmaW5lIENJQ1I0X1ZTUAkoMSA8PCAyMCkJLyog
VmVydGljYWwgc3luYyBwb2xhcml0eSAqLworI2RlZmluZSBDSUNSNF9NQ0xLX0VOCSgxIDw8IDE5
KQkvKiBNQ0xLIGVuYWJsZSAqLworI2RlZmluZSBDSUNSNF9GUl9SQVRFCSgweDcgPDwgOCkJLyog
RnJhbWUgcmF0ZSBtYXNrICovCisjZGVmaW5lIENJQ1I0X0RJVgkoMHhmZiA8PCAwKQkvKiBDbG9j
ayBkaXZpc29yIG1hc2sgKi8KKworI2RlZmluZSBDSVNSX0ZUTwkoMSA8PCAxNSkJLyogRklGTyB0
aW1lLW91dCAqLworI2RlZmluZSBDSVNSX1JEQVZfMgkoMSA8PCAxNCkJLyogQ2hhbm5lbCAyIHJl
Y2VpdmUgZGF0YSBhdmFpbGFibGUgKi8KKyNkZWZpbmUgQ0lTUl9SREFWXzEJKDEgPDwgMTMpCS8q
IENoYW5uZWwgMSByZWNlaXZlIGRhdGEgYXZhaWxhYmxlICovCisjZGVmaW5lIENJU1JfUkRBVl8w
CSgxIDw8IDEyKQkvKiBDaGFubmVsIDAgcmVjZWl2ZSBkYXRhIGF2YWlsYWJsZSAqLworI2RlZmlu
ZSBDSVNSX0ZFTVBUWV8yCSgxIDw8IDExKQkvKiBDaGFubmVsIDIgRklGTyBlbXB0eSAqLworI2Rl
ZmluZSBDSVNSX0ZFTVBUWV8xCSgxIDw8IDEwKQkvKiBDaGFubmVsIDEgRklGTyBlbXB0eSAqLwor
I2RlZmluZSBDSVNSX0ZFTVBUWV8wCSgxIDw8IDkpCS8qIENoYW5uZWwgMCBGSUZPIGVtcHR5ICov
CisjZGVmaW5lIENJU1JfRU9MCSgxIDw8IDgpCS8qIEVuZCBvZiBsaW5lICovCisjZGVmaW5lIENJ
U1JfUEFSX0VSUgkoMSA8PCA3KQkvKiBQYXJpdHkgZXJyb3IgKi8KKyNkZWZpbmUgQ0lTUl9DUUQJ
KDEgPDwgNikJLyogQ2FtZXJhIGludGVyZmFjZSBxdWljayBkaXNhYmxlICovCisjZGVmaW5lIENJ
U1JfQ0RECSgxIDw8IDUpCS8qIENhbWVyYSBpbnRlcmZhY2UgZGlzYWJsZSBkb25lICovCisjZGVm
aW5lIENJU1JfU09GCSgxIDw8IDQpCS8qIFN0YXJ0IG9mIGZyYW1lICovCisjZGVmaW5lIENJU1Jf
RU9GCSgxIDw8IDMpCS8qIEVuZCBvZiBmcmFtZSAqLworI2RlZmluZSBDSVNSX0lGT18yCSgxIDw8
IDIpCS8qIEZJRk8gb3ZlcnJ1biBmb3IgQ2hhbm5lbCAyICovCisjZGVmaW5lIENJU1JfSUZPXzEJ
KDEgPDwgMSkJLyogRklGTyBvdmVycnVuIGZvciBDaGFubmVsIDEgKi8KKyNkZWZpbmUgQ0lTUl9J
Rk9fMAkoMSA8PCAwKQkvKiBGSUZPIG92ZXJydW4gZm9yIENoYW5uZWwgMCAqLworCisjZGVmaW5l
IENJRlJfRkxWTDIJKDB4N2YgPDwgMjMpCS8qIEZJRk8gMiBsZXZlbCBtYXNrICovCisjZGVmaW5l
IENJRlJfRkxWTDEJKDB4N2YgPDwgMTYpCS8qIEZJRk8gMSBsZXZlbCBtYXNrICovCisjZGVmaW5l
IENJRlJfRkxWTDAJKDB4ZmYgPDwgOCkJLyogRklGTyAwIGxldmVsIG1hc2sgKi8KKyNkZWZpbmUg
Q0lGUl9USExfMAkoMHgzIDw8IDQpCS8qIFRocmVzaG9sZCBMZXZlbCBmb3IgQ2hhbm5lbCAwIEZJ
Rk8gKi8KKyNkZWZpbmUgQ0lGUl9SRVNFVF9GCSgxIDw8IDMpCS8qIFJlc2V0IGlucHV0IEZJRk9z
ICovCisjZGVmaW5lIENJRlJfRkVOMgkoMSA8PCAyKQkvKiBGSUZPIGVuYWJsZSBmb3IgY2hhbm5l
bCAyICovCisjZGVmaW5lIENJRlJfRkVOMQkoMSA8PCAxKQkvKiBGSUZPIGVuYWJsZSBmb3IgY2hh
bm5lbCAxICovCisjZGVmaW5lIENJRlJfRkVOMAkoMSA8PCAwKQkvKiBGSUZPIGVuYWJsZSBmb3Ig
Y2hhbm5lbCAwICovCisKICNkZWZpbmUgQ0lDUjBfU0lNX01QCSgwIDw8IDI0KQogI2RlZmluZSBD
SUNSMF9TSU1fU1AJKDEgPDwgMjQpCiAjZGVmaW5lIENJQ1IwX1NJTV9NUwkoMiA8PCAyNCkKQEAg
LTM4Nyw3ICs0ODAsMTAgQEAgc3RhdGljIHZvaWQgcHhhX3ZpZGVvYnVmX3F1ZXVlKHN0cnVjdCB2
aWRlb2J1Zl9xdWV1ZSAqdnEsCiAJYWN0aXZlID0gcGNkZXYtPmFjdGl2ZTsKIAogCWlmICghYWN0
aXZlKSB7Ci0JCUNJRlIgfD0gQ0lGUl9SRVNFVF9GOworCQl1bnNpZ25lZCBsb25nIGNpZnIsIGNp
Y3IwOworCisJCWNpZnIgPSBfX3Jhd19yZWFkbChwY2Rldi0+YmFzZSArIENJRlIpIHwgQ0lGUl9S
RVNFVF9GOworCQlfX3Jhd193cml0ZWwoY2lmciwgcGNkZXYtPmJhc2UgKyBDSUZSKTsKIAogCQlm
b3IgKGkgPSAwOyBpIDwgcGNkZXYtPmNoYW5uZWxzOyBpKyspIHsKIAkJCUREQURSKHBjZGV2LT5k
bWFfY2hhbnNbaV0pID0gYnVmLT5kbWFzW2ldLnNnX2RtYTsKQEAgLTM5Niw3ICs0OTIsOSBAQCBz
dGF0aWMgdm9pZCBweGFfdmlkZW9idWZfcXVldWUoc3RydWN0IHZpZGVvYnVmX3F1ZXVlICp2cSwK
IAkJfQogCiAJCXBjZGV2LT5hY3RpdmUgPSBidWY7Ci0JCUNJQ1IwIHw9IENJQ1IwX0VOQjsKKwor
CQljaWNyMCA9IF9fcmF3X3JlYWRsKHBjZGV2LT5iYXNlICsgQ0lDUjApIHwgQ0lDUjBfRU5COwor
CQlfX3Jhd193cml0ZWwoY2ljcjAsIHBjZGV2LT5iYXNlICsgQ0lDUjApOwogCX0gZWxzZSB7CiAJ
CXN0cnVjdCBweGFfY2FtX2RtYSAqYnVmX2RtYTsKIAkJc3RydWN0IHB4YV9jYW1fZG1hICphY3Rf
ZG1hOwpAQCAtNDgwLDYgKzU3OCw4IEBAIHN0YXRpYyB2b2lkIHB4YV9jYW1lcmFfd2FrZXVwKHN0
cnVjdCBweGFfY2FtZXJhX2RldiAqcGNkZXYsCiAJCQkgICAgICBzdHJ1Y3QgdmlkZW9idWZfYnVm
ZmVyICp2YiwKIAkJCSAgICAgIHN0cnVjdCBweGFfYnVmZmVyICpidWYpCiB7CisJdW5zaWduZWQg
bG9uZyBjaWNyMDsKKwogCS8qIF9pbml0IGlzIHVzZWQgdG8gZGVidWcgcmFjZXMsIHNlZSBjb21t
ZW50IGluIHB4YV9jYW1lcmFfcmVxYnVmcygpICovCiAJbGlzdF9kZWxfaW5pdCgmdmItPnF1ZXVl
KTsKIAl2Yi0+c3RhdGUgPSBWSURFT0JVRl9ET05FOwpAQCAtNDkyLDcgKzU5Miw5IEBAIHN0YXRp
YyB2b2lkIHB4YV9jYW1lcmFfd2FrZXVwKHN0cnVjdCBweGFfY2FtZXJhX2RldiAqcGNkZXYsCiAJ
CURDU1IocGNkZXYtPmRtYV9jaGFuc1swXSkgPSAwOwogCQlEQ1NSKHBjZGV2LT5kbWFfY2hhbnNb
MV0pID0gMDsKIAkJRENTUihwY2Rldi0+ZG1hX2NoYW5zWzJdKSA9IDA7Ci0JCUNJQ1IwICY9IH5D
SUNSMF9FTkI7CisKKwkJY2ljcjAgPSBfX3Jhd19yZWFkbChwY2Rldi0+YmFzZSArIENJQ1IwKSAm
IH5DSUNSMF9FTkI7CisJCV9fcmF3X3dyaXRlbChjaWNyMCwgcGNkZXYtPmJhc2UgKyBDSUNSMCk7
CiAJCXJldHVybjsKIAl9CiAKQEAgLTUwNyw2ICs2MDksNyBAQCBzdGF0aWMgdm9pZCBweGFfY2Ft
ZXJhX2RtYV9pcnEoaW50IGNoYW5uZWwsIHN0cnVjdCBweGFfY2FtZXJhX2RldiAqcGNkZXYsCiAJ
dW5zaWduZWQgbG9uZyBmbGFnczsKIAl1MzIgc3RhdHVzLCBjYW1lcmFfc3RhdHVzLCBvdmVycnVu
OwogCXN0cnVjdCB2aWRlb2J1Zl9idWZmZXIgKnZiOworCXVuc2lnbmVkIGxvbmcgY2lmciwgY2lj
cjA7CiAKIAlzcGluX2xvY2tfaXJxc2F2ZSgmcGNkZXYtPmxvY2ssIGZsYWdzKTsKIApAQCAtNTI5
LDIyICs2MzIsMjYgQEAgc3RhdGljIHZvaWQgcHhhX2NhbWVyYV9kbWFfaXJxKGludCBjaGFubmVs
LCBzdHJ1Y3QgcHhhX2NhbWVyYV9kZXYgKnBjZGV2LAogCQlnb3RvIG91dDsKIAl9CiAKLQljYW1l
cmFfc3RhdHVzID0gQ0lTUjsKKwljYW1lcmFfc3RhdHVzID0gX19yYXdfcmVhZGwocGNkZXYtPmJh
c2UgKyBDSVNSKTsKIAlvdmVycnVuID0gQ0lTUl9JRk9fMDsKIAlpZiAocGNkZXYtPmNoYW5uZWxz
ID09IDMpCiAJCW92ZXJydW4gfD0gQ0lTUl9JRk9fMSB8IENJU1JfSUZPXzI7CiAJaWYgKGNhbWVy
YV9zdGF0dXMgJiBvdmVycnVuKSB7CiAJCWRldl9kYmcocGNkZXYtPmRldiwgIkZJRk8gb3ZlcnJ1
biEgQ0lTUjogJXhcbiIsIGNhbWVyYV9zdGF0dXMpOwogCQkvKiBTdG9wIHRoZSBDYXB0dXJlIElu
dGVyZmFjZSAqLwotCQlDSUNSMCAmPSB+Q0lDUjBfRU5COworCQljaWNyMCA9IF9fcmF3X3JlYWRs
KHBjZGV2LT5iYXNlICsgQ0lDUjApICYgfkNJQ1IwX0VOQjsKKwkJX19yYXdfd3JpdGVsKGNpY3Iw
LCBwY2Rldi0+YmFzZSArIENJQ1IwKTsKKwogCQkvKiBTdG9wIERNQSAqLwogCQlEQ1NSKGNoYW5u
ZWwpID0gMDsKIAkJLyogUmVzZXQgdGhlIEZJRk9zICovCi0JCUNJRlIgfD0gQ0lGUl9SRVNFVF9G
OworCQljaWZyID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUZSKSB8IENJRlJfUkVTRVRf
RjsKKwkJX19yYXdfd3JpdGVsKGNpZnIsIHBjZGV2LT5iYXNlICsgQ0lGUik7CiAJCS8qIEVuYWJs
ZSBFbmQtT2YtRnJhbWUgSW50ZXJydXB0ICovCi0JCUNJQ1IwICY9IH5DSUNSMF9FT0ZNOworCQlj
aWNyMCAmPSB+Q0lDUjBfRU9GTTsKKwkJX19yYXdfd3JpdGVsKGNpY3IwLCBwY2Rldi0+YmFzZSAr
IENJQ1IwKTsKIAkJLyogUmVzdGFydCB0aGUgQ2FwdHVyZSBJbnRlcmZhY2UgKi8KLQkJQ0lDUjAg
fD0gQ0lDUjBfRU5COworCQlfX3Jhd193cml0ZWwoY2ljcjAgfCBDSUNSMF9FTkIsIHBjZGV2LT5i
YXNlICsgQ0lDUjApOwogCQlnb3RvIG91dDsKIAl9CiAKQEAgLTYzMSw3ICs3MzgsOCBAQCBzdGF0
aWMgdm9pZCBweGFfY2FtZXJhX2FjdGl2YXRlKHN0cnVjdCBweGFfY2FtZXJhX2RldiAqcGNkZXYp
CiAJCXBkYXRhLT5pbml0KHBjZGV2LT5kZXYpOwogCX0KIAotCUNJQ1IwID0gMHgzRkY7ICAgLyog
ZGlzYWJsZSBhbGwgaW50ZXJydXB0cyAqLworCS8qIGRpc2FibGUgYWxsIGludGVycnVwdHMgKi8K
KwlfX3Jhd193cml0ZWwoMHgzZmYsIHBjZGV2LT5iYXNlICsgQ0lDUjApOwkKIAogCWlmIChwY2Rl
di0+cGxhdGZvcm1fZmxhZ3MgJiBQWEFfQ0FNRVJBX1BDTEtfRU4pCiAJCWNpY3I0IHw9IENJQ1I0
X1BDTEtfRU47CkBAIC02NDQsNyArNzUyLDggQEAgc3RhdGljIHZvaWQgcHhhX2NhbWVyYV9hY3Rp
dmF0ZShzdHJ1Y3QgcHhhX2NhbWVyYV9kZXYgKnBjZGV2KQogCWlmIChwY2Rldi0+cGxhdGZvcm1f
ZmxhZ3MgJiBQWEFfQ0FNRVJBX1ZTUCkKIAkJY2ljcjQgfD0gQ0lDUjRfVlNQOwogCi0JQ0lDUjQg
PSBtY2xrX2dldF9kaXZpc29yKHBjZGV2KSB8IGNpY3I0OworCWNpY3I0IHw9IG1jbGtfZ2V0X2Rp
dmlzb3IocGNkZXYpOworCV9fcmF3X3dyaXRlbChjaWNyNCwgcGNkZXYtPmJhc2UgKyBDSUNSNCk7
CiAKIAljbGtfZW5hYmxlKHBjZGV2LT5jbGspOwogfQpAQCAtNjU3LDE0ICs3NjYsMTUgQEAgc3Rh
dGljIHZvaWQgcHhhX2NhbWVyYV9kZWFjdGl2YXRlKHN0cnVjdCBweGFfY2FtZXJhX2RldiAqcGNk
ZXYpCiBzdGF0aWMgaXJxcmV0dXJuX3QgcHhhX2NhbWVyYV9pcnEoaW50IGlycSwgdm9pZCAqZGF0
YSkKIHsKIAlzdHJ1Y3QgcHhhX2NhbWVyYV9kZXYgKnBjZGV2ID0gZGF0YTsKLQl1bnNpZ25lZCBp
bnQgc3RhdHVzID0gQ0lTUjsKKwl1bnNpZ25lZCBsb25nIHN0YXR1cywgY2ljcjA7CiAKLQlkZXZf
ZGJnKHBjZGV2LT5kZXYsICJDYW1lcmEgaW50ZXJydXB0IHN0YXR1cyAweCV4XG4iLCBzdGF0dXMp
OworCXN0YXR1cyA9IF9fcmF3X3JlYWRsKHBjZGV2LT5iYXNlICsgQ0lTUik7CisJZGV2X2RiZyhw
Y2Rldi0+ZGV2LCAiQ2FtZXJhIGludGVycnVwdCBzdGF0dXMgMHglbHhcbiIsIHN0YXR1cyk7CiAK
IAlpZiAoIXN0YXR1cykKIAkJcmV0dXJuIElSUV9OT05FOwogCi0JQ0lTUiA9IHN0YXR1czsKKwlf
X3Jhd193cml0ZWwoc3RhdHVzLCBwY2Rldi0+YmFzZSArIENJU1IpOwogCiAJaWYgKHN0YXR1cyAm
IENJU1JfRU9GKSB7CiAJCWludCBpOwpAQCAtNjczLDcgKzc4Myw4IEBAIHN0YXRpYyBpcnFyZXR1
cm5fdCBweGFfY2FtZXJhX2lycShpbnQgaXJxLCB2b2lkICpkYXRhKQogCQkJCXBjZGV2LT5hY3Rp
dmUtPmRtYXNbaV0uc2dfZG1hOwogCQkJRENTUihwY2Rldi0+ZG1hX2NoYW5zW2ldKSA9IERDU1Jf
UlVOOwogCQl9Ci0JCUNJQ1IwIHw9IENJQ1IwX0VPRk07CisJCWNpY3IwID0gX19yYXdfcmVhZGwo
cGNkZXYtPmJhc2UgKyBDSUNSMCkgfCBDSUNSMF9FT0ZNOworCQlfX3Jhd193cml0ZWwoY2ljcjAs
IHBjZGV2LT5iYXNlICsgQ0lDUjApOwogCX0KIAogCXJldHVybiBJUlFfSEFORExFRDsKQEAgLTcy
MCw3ICs4MzEsNyBAQCBzdGF0aWMgdm9pZCBweGFfY2FtZXJhX3JlbW92ZV9kZXZpY2Uoc3RydWN0
IHNvY19jYW1lcmFfZGV2aWNlICppY2QpCiAJCSBpY2QtPmRldm51bSk7CiAKIAkvKiBkaXNhYmxl
IGNhcHR1cmUsIGRpc2FibGUgaW50ZXJydXB0cyAqLwotCUNJQ1IwID0gMHgzZmY7CisJX19yYXdf
d3JpdGVsKDB4M2ZmLCBwY2Rldi0+YmFzZSArIENJQ1IwKTsKIAogCS8qIFN0b3AgRE1BIGVuZ2lu
ZSAqLwogCURDU1IocGNkZXYtPmRtYV9jaGFuc1swXSkgPSAwOwpAQCAtNzc4LDcgKzg4OSw3IEBA
IHN0YXRpYyBpbnQgcHhhX2NhbWVyYV9zZXRfYnVzX3BhcmFtKHN0cnVjdCBzb2NfY2FtZXJhX2Rl
dmljZSAqaWNkLCBfX3UzMiBwaXhmbXQpCiAJCXRvX3NvY19jYW1lcmFfaG9zdChpY2QtPmRldi5w
YXJlbnQpOwogCXN0cnVjdCBweGFfY2FtZXJhX2RldiAqcGNkZXYgPSBpY2ktPnByaXY7CiAJdW5z
aWduZWQgbG9uZyBkdywgYnBwLCBidXNfZmxhZ3MsIGNhbWVyYV9mbGFncywgY29tbW9uX2ZsYWdz
OwotCXUzMiBjaWNyMCwgY2ljcjEsIGNpY3I0ID0gMDsKKwl1MzIgY2ljcjAsIGNpY3IxLCBjaWNy
MiwgY2ljcjMsIGNpY3I0ID0gMDsKIAlpbnQgcmV0ID0gdGVzdF9wbGF0Zm9ybV9wYXJhbShwY2Rl
diwgaWNkLT5idXN3aWR0aCwgJmJ1c19mbGFncyk7CiAKIAlpZiAocmV0IDwgMCkKQEAgLTg1NCw5
ICs5NjUsOSBAQCBzdGF0aWMgaW50IHB4YV9jYW1lcmFfc2V0X2J1c19wYXJhbShzdHJ1Y3Qgc29j
X2NhbWVyYV9kZXZpY2UgKmljZCwgX191MzIgcGl4Zm10KQogCWlmIChjb21tb25fZmxhZ3MgJiBT
T0NBTV9WU1lOQ19BQ1RJVkVfTE9XKQogCQljaWNyNCB8PSBDSUNSNF9WU1A7CiAKLQljaWNyMCA9
IENJQ1IwOworCWNpY3IwID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSMCk7CiAJaWYg
KGNpY3IwICYgQ0lDUjBfRU5CKQotCQlDSUNSMCA9IGNpY3IwICYgfkNJQ1IwX0VOQjsKKwkJX19y
YXdfd3JpdGVsKGNpY3IwICYgfkNJQ1IwX0VOQiwgcGNkZXYtPmJhc2UgKyBDSUNSMCk7CiAKIAlj
aWNyMSA9IENJQ1IxX1BQTF9WQUwoaWNkLT53aWR0aCAtIDEpIHwgYnBwIHwgZHc7CiAKQEAgLTg3
NiwxNiArOTg3LDIxIEBAIHN0YXRpYyBpbnQgcHhhX2NhbWVyYV9zZXRfYnVzX3BhcmFtKHN0cnVj
dCBzb2NfY2FtZXJhX2RldmljZSAqaWNkLCBfX3UzMiBwaXhmbXQpCiAJCWJyZWFrOwogCX0KIAot
CUNJQ1IxID0gY2ljcjE7Ci0JQ0lDUjIgPSAwOwotCUNJQ1IzID0gQ0lDUjNfTFBGX1ZBTChpY2Qt
PmhlaWdodCAtIDEpIHwKKwljaWNyMiA9IDA7CisJY2ljcjMgPSBDSUNSM19MUEZfVkFMKGljZC0+
aGVpZ2h0IC0gMSkgfAogCQlDSUNSM19CRldfVkFMKG1pbigodW5zaWduZWQgc2hvcnQpMjU1LCBp
Y2QtPnlfc2tpcF90b3ApKTsKLQlDSUNSNCA9IG1jbGtfZ2V0X2Rpdmlzb3IocGNkZXYpIHwgY2lj
cjQ7CisJY2ljcjQgfD0gbWNsa19nZXRfZGl2aXNvcihwY2Rldik7CisKKwlfX3Jhd193cml0ZWwo
Y2ljcjEsIHBjZGV2LT5iYXNlICsgQ0lDUjEpOworCV9fcmF3X3dyaXRlbChjaWNyMiwgcGNkZXYt
PmJhc2UgKyBDSUNSMik7CisJX19yYXdfd3JpdGVsKGNpY3IzLCBwY2Rldi0+YmFzZSArIENJQ1Iz
KTsKKwlfX3Jhd193cml0ZWwoY2ljcjQsIHBjZGV2LT5iYXNlICsgQ0lDUjQpOwogCiAJLyogQ0lG
IGludGVycnVwdHMgYXJlIG5vdCB1c2VkLCBvbmx5IERNQSAqLwotCUNJQ1IwID0gKHBjZGV2LT5w
bGF0Zm9ybV9mbGFncyAmIFBYQV9DQU1FUkFfTUFTVEVSID8KLQkJIENJQ1IwX1NJTV9NUCA6IChD
SUNSMF9TTF9DQVBfRU4gfCBDSUNSMF9TSU1fU1ApKSB8Ci0JCUNJQ1IwX0RNQUVOIHwgQ0lDUjBf
SVJRX01BU0sgfCAoY2ljcjAgJiBDSUNSMF9FTkIpOworCWNpY3IwID0gKGNpY3IwICYgQ0lDUjBf
RU5CKSB8IChwY2Rldi0+cGxhdGZvcm1fZmxhZ3MgJiBQWEFfQ0FNRVJBX01BU1RFUiA/CisJCUNJ
Q1IwX1NJTV9NUCA6IChDSUNSMF9TTF9DQVBfRU4gfCBDSUNSMF9TSU1fU1ApKTsKKwljaWNyMCB8
PSBDSUNSMF9ETUFFTiB8IENJQ1IwX0lSUV9NQVNLOworCV9fcmF3X3dyaXRlbChjaWNyMCwgcGNk
ZXYtPmJhc2UgKyBDSUNSMCk7CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTk4NCwxMSArMTEwMCwxMSBA
QCBzdGF0aWMgaW50IHB4YV9jYW1lcmFfc3VzcGVuZChzdHJ1Y3Qgc29jX2NhbWVyYV9kZXZpY2Ug
KmljZCwgcG1fbWVzc2FnZV90IHN0YXRlKQogCXN0cnVjdCBweGFfY2FtZXJhX2RldiAqcGNkZXYg
PSBpY2ktPnByaXY7CiAJaW50IGkgPSAwLCByZXQgPSAwOwogCi0JcGNkZXYtPnNhdmVfY2ljcltp
KytdID0gQ0lDUjA7Ci0JcGNkZXYtPnNhdmVfY2ljcltpKytdID0gQ0lDUjE7Ci0JcGNkZXYtPnNh
dmVfY2ljcltpKytdID0gQ0lDUjI7Ci0JcGNkZXYtPnNhdmVfY2ljcltpKytdID0gQ0lDUjM7Ci0J
cGNkZXYtPnNhdmVfY2ljcltpKytdID0gQ0lDUjQ7CisJcGNkZXYtPnNhdmVfY2ljcltpKytdID0g
X19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSMCk7CisJcGNkZXYtPnNhdmVfY2ljcltpKytd
ID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSMSk7CisJcGNkZXYtPnNhdmVfY2ljcltp
KytdID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSMik7CisJcGNkZXYtPnNhdmVfY2lj
cltpKytdID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSMyk7CisJcGNkZXYtPnNhdmVf
Y2ljcltpKytdID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSNCk7CiAKIAlpZiAoKHBj
ZGV2LT5pY2QpICYmIChwY2Rldi0+aWNkLT5vcHMtPnN1c3BlbmQpKQogCQlyZXQgPSBwY2Rldi0+
aWNkLT5vcHMtPnN1c3BlbmQocGNkZXYtPmljZCwgc3RhdGUpOwpAQCAtMTAwNywyMyArMTEyMywy
NyBAQCBzdGF0aWMgaW50IHB4YV9jYW1lcmFfcmVzdW1lKHN0cnVjdCBzb2NfY2FtZXJhX2Rldmlj
ZSAqaWNkKQogCURSQ01SKDY5KSA9IHBjZGV2LT5kbWFfY2hhbnNbMV0gfCBEUkNNUl9NQVBWTEQ7
CiAJRFJDTVIoNzApID0gcGNkZXYtPmRtYV9jaGFuc1syXSB8IERSQ01SX01BUFZMRDsKIAotCUNJ
Q1IwID0gcGNkZXYtPnNhdmVfY2ljcltpKytdICYgfkNJQ1IwX0VOQjsKLQlDSUNSMSA9IHBjZGV2
LT5zYXZlX2NpY3JbaSsrXTsKLQlDSUNSMiA9IHBjZGV2LT5zYXZlX2NpY3JbaSsrXTsKLQlDSUNS
MyA9IHBjZGV2LT5zYXZlX2NpY3JbaSsrXTsKLQlDSUNSNCA9IHBjZGV2LT5zYXZlX2NpY3JbaSsr
XTsKKwlfX3Jhd193cml0ZWwocGNkZXYtPnNhdmVfY2ljcltpKytdICYgfkNJQ1IwX0VOQiwgcGNk
ZXYtPmJhc2UgKyBDSUNSMCk7CisJX19yYXdfd3JpdGVsKHBjZGV2LT5zYXZlX2NpY3JbaSsrXSwg
cGNkZXYtPmJhc2UgKyBDSUNSMSk7CisJX19yYXdfd3JpdGVsKHBjZGV2LT5zYXZlX2NpY3JbaSsr
XSwgcGNkZXYtPmJhc2UgKyBDSUNSMik7CisJX19yYXdfd3JpdGVsKHBjZGV2LT5zYXZlX2NpY3Jb
aSsrXSwgcGNkZXYtPmJhc2UgKyBDSUNSMyk7CisJX19yYXdfd3JpdGVsKHBjZGV2LT5zYXZlX2Np
Y3JbaSsrXSwgcGNkZXYtPmJhc2UgKyBDSUNSNCk7CiAKIAlpZiAoKHBjZGV2LT5pY2QpICYmIChw
Y2Rldi0+aWNkLT5vcHMtPnJlc3VtZSkpCiAJCXJldCA9IHBjZGV2LT5pY2QtPm9wcy0+cmVzdW1l
KHBjZGV2LT5pY2QpOwogCiAJLyogUmVzdGFydCBmcmFtZSBjYXB0dXJlIGlmIGFjdGl2ZSBidWZm
ZXIgZXhpc3RzICovCiAJaWYgKCFyZXQgJiYgcGNkZXYtPmFjdGl2ZSkgeworCQl1bnNpZ25lZCBs
b25nIGNpZnIsIGNpY3IwOworCiAJCS8qIFJlc2V0IHRoZSBGSUZPcyAqLwotCQlDSUZSIHw9IENJ
RlJfUkVTRVRfRjsKLQkJLyogRW5hYmxlIEVuZC1PZi1GcmFtZSBJbnRlcnJ1cHQgKi8KLQkJQ0lD
UjAgJj0gfkNJQ1IwX0VPRk07Ci0JCS8qIFJlc3RhcnQgdGhlIENhcHR1cmUgSW50ZXJmYWNlICov
Ci0JCUNJQ1IwIHw9IENJQ1IwX0VOQjsKKwkJY2lmciA9IF9fcmF3X3JlYWRsKHBjZGV2LT5iYXNl
ICsgQ0lGUikgfCBDSUZSX1JFU0VUX0Y7CisJCV9fcmF3X3dyaXRlbChjaWZyLCBwY2Rldi0+YmFz
ZSArIENJRlIpOworCisJCWNpY3IwID0gX19yYXdfcmVhZGwocGNkZXYtPmJhc2UgKyBDSUNSMCk7
CisJCWNpY3IwICY9IH5DSUNSMF9FT0ZNOwkvKiBFbmFibGUgRW5kLU9mLUZyYW1lIEludGVycnVw
dCAqLworCQljaWNyMCB8PSBDSUNSMF9FTkI7CS8qIFJlc3RhcnQgdGhlIENhcHR1cmUgSW50ZXJm
YWNlICovCisJCV9fcmF3X3dyaXRlbChjaWNyMCwgcGNkZXYtPmJhc2UgKyBDSUNSMCk7CiAJfQog
CiAJcmV0dXJuIHJldDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vcHhhX2NhbWVy
YS5oIGIvZHJpdmVycy9tZWRpYS92aWRlby9weGFfY2FtZXJhLmgKZGVsZXRlZCBmaWxlIG1vZGUg
MTAwNjQ0CmluZGV4IDg5Y2JmYzkuLjAwMDAwMDAKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9w
eGFfY2FtZXJhLmgKKysrIC9kZXYvbnVsbApAQCAtMSw5NSArMCwwIEBACi0vKiBDYW1lcmEgSW50
ZXJmYWNlICovCi0jZGVmaW5lIENJQ1IwCQlfX1JFRygweDUwMDAwMDAwKQotI2RlZmluZSBDSUNS
MQkJX19SRUcoMHg1MDAwMDAwNCkKLSNkZWZpbmUgQ0lDUjIJCV9fUkVHKDB4NTAwMDAwMDgpCi0j
ZGVmaW5lIENJQ1IzCQlfX1JFRygweDUwMDAwMDBDKQotI2RlZmluZSBDSUNSNAkJX19SRUcoMHg1
MDAwMDAxMCkKLSNkZWZpbmUgQ0lTUgkJX19SRUcoMHg1MDAwMDAxNCkKLSNkZWZpbmUgQ0lGUgkJ
X19SRUcoMHg1MDAwMDAxOCkKLSNkZWZpbmUgQ0lUT1IJCV9fUkVHKDB4NTAwMDAwMUMpCi0jZGVm
aW5lIENJQlIwCQlfX1JFRygweDUwMDAwMDI4KQotI2RlZmluZSBDSUJSMQkJX19SRUcoMHg1MDAw
MDAzMCkKLSNkZWZpbmUgQ0lCUjIJCV9fUkVHKDB4NTAwMDAwMzgpCi0KLSNkZWZpbmUgQ0lDUjBf
RE1BRU4JKDEgPDwgMzEpCS8qIERNQSByZXF1ZXN0IGVuYWJsZSAqLwotI2RlZmluZSBDSUNSMF9Q
QVJfRU4JKDEgPDwgMzApCS8qIFBhcml0eSBlbmFibGUgKi8KLSNkZWZpbmUgQ0lDUjBfU0xfQ0FQ
X0VOCSgxIDw8IDI5KQkvKiBDYXB0dXJlIGVuYWJsZSBmb3Igc2xhdmUgbW9kZSAqLwotI2RlZmlu
ZSBDSUNSMF9FTkIJKDEgPDwgMjgpCS8qIENhbWVyYSBpbnRlcmZhY2UgZW5hYmxlICovCi0jZGVm
aW5lIENJQ1IwX0RJUwkoMSA8PCAyNykJLyogQ2FtZXJhIGludGVyZmFjZSBkaXNhYmxlICovCi0j
ZGVmaW5lIENJQ1IwX1NJTQkoMHg3IDw8IDI0KQkvKiBTZW5zb3IgaW50ZXJmYWNlIG1vZGUgbWFz
ayAqLwotI2RlZmluZSBDSUNSMF9UT00JKDEgPDwgOSkJLyogVGltZS1vdXQgbWFzayAqLwotI2Rl
ZmluZSBDSUNSMF9SREFWTQkoMSA8PCA4KQkvKiBSZWNlaXZlLWRhdGEtYXZhaWxhYmxlIG1hc2sg
Ki8KLSNkZWZpbmUgQ0lDUjBfRkVNCSgxIDw8IDcpCS8qIEZJRk8tZW1wdHkgbWFzayAqLwotI2Rl
ZmluZSBDSUNSMF9FT0xNCSgxIDw8IDYpCS8qIEVuZC1vZi1saW5lIG1hc2sgKi8KLSNkZWZpbmUg
Q0lDUjBfUEVSUk0JKDEgPDwgNSkJLyogUGFyaXR5LWVycm9yIG1hc2sgKi8KLSNkZWZpbmUgQ0lD
UjBfUURNCSgxIDw8IDQpCS8qIFF1aWNrLWRpc2FibGUgbWFzayAqLwotI2RlZmluZSBDSUNSMF9D
RE0JKDEgPDwgMykJLyogRGlzYWJsZS1kb25lIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjBfU09GTQko
MSA8PCAyKQkvKiBTdGFydC1vZi1mcmFtZSBtYXNrICovCi0jZGVmaW5lIENJQ1IwX0VPRk0JKDEg
PDwgMSkJLyogRW5kLW9mLWZyYW1lIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjBfRk9NCSgxIDw8IDAp
CS8qIEZJRk8tb3ZlcnJ1biBtYXNrICovCi0KLSNkZWZpbmUgQ0lDUjFfVEJJVAkoMSA8PCAzMSkJ
LyogVHJhbnNwYXJlbmN5IGJpdCAqLwotI2RlZmluZSBDSUNSMV9SR0JUX0NPTlYJKDB4MyA8PCAy
OSkJLyogUkdCVCBjb252ZXJzaW9uIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjFfUFBMCSgweDdmZiA8
PCAxNSkJLyogUGl4ZWxzIHBlciBsaW5lIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjFfUkdCX0NPTlYJ
KDB4NyA8PCAxMikJLyogUkdCIGNvbnZlcnNpb24gbWFzayAqLwotI2RlZmluZSBDSUNSMV9SR0Jf
RgkoMSA8PCAxMSkJLyogUkdCIGZvcm1hdCAqLwotI2RlZmluZSBDSUNSMV9ZQ0JDUl9GCSgxIDw8
IDEwKQkvKiBZQ2JDciBmb3JtYXQgKi8KLSNkZWZpbmUgQ0lDUjFfUkdCX0JQUAkoMHg3IDw8IDcp
CS8qIFJHQiBiaXMgcGVyIHBpeGVsIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjFfUkFXX0JQUAkoMHgz
IDw8IDUpCS8qIFJhdyBiaXMgcGVyIHBpeGVsIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjFfQ09MT1Jf
U1AJKDB4MyA8PCAzKQkvKiBDb2xvciBzcGFjZSBtYXNrICovCi0jZGVmaW5lIENJQ1IxX0RXCSgw
eDcgPDwgMCkJLyogRGF0YSB3aWR0aCBtYXNrICovCi0KLSNkZWZpbmUgQ0lDUjJfQkxXCSgweGZm
IDw8IDI0KQkvKiBCZWdpbm5pbmctb2YtbGluZSBwaXhlbCBjbG9jawotCQkJCQkgICB3YWl0IGNv
dW50IG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjJfRUxXCSgweGZmIDw8IDE2KQkvKiBFbmQtb2YtbGlu
ZSBwaXhlbCBjbG9jawotCQkJCQkgICB3YWl0IGNvdW50IG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjJf
SFNXCSgweDNmIDw8IDEwKQkvKiBIb3Jpem9udGFsIHN5bmMgcHVsc2Ugd2lkdGggbWFzayAqLwot
I2RlZmluZSBDSUNSMl9CRlBXCSgweDNmIDw8IDMpCS8qIEJlZ2lubmluZy1vZi1mcmFtZSBwaXhl
bCBjbG9jawotCQkJCQkgICB3YWl0IGNvdW50IG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjJfRlNXCSgw
eDcgPDwgMCkJLyogRnJhbWUgc3RhYmlsaXphdGlvbgotCQkJCQkgICB3YWl0IGNvdW50IG1hc2sg
Ki8KLQotI2RlZmluZSBDSUNSM19CRlcJKDB4ZmYgPDwgMjQpCS8qIEJlZ2lubmluZy1vZi1mcmFt
ZSBsaW5lIGNsb2NrCi0JCQkJCSAgIHdhaXQgY291bnQgbWFzayAqLwotI2RlZmluZSBDSUNSM19F
RlcJKDB4ZmYgPDwgMTYpCS8qIEVuZC1vZi1mcmFtZSBsaW5lIGNsb2NrCi0JCQkJCSAgIHdhaXQg
Y291bnQgbWFzayAqLwotI2RlZmluZSBDSUNSM19WU1cJKDB4M2YgPDwgMTApCS8qIFZlcnRpY2Fs
IHN5bmMgcHVsc2Ugd2lkdGggbWFzayAqLwotI2RlZmluZSBDSUNSM19CRlBXCSgweDNmIDw8IDMp
CS8qIEJlZ2lubmluZy1vZi1mcmFtZSBwaXhlbCBjbG9jawotCQkJCQkgICB3YWl0IGNvdW50IG1h
c2sgKi8KLSNkZWZpbmUgQ0lDUjNfTFBGCSgweDdmZiA8PCAwKQkvKiBMaW5lcyBwZXIgZnJhbWUg
bWFzayAqLwotCi0jZGVmaW5lIENJQ1I0X01DTEtfRExZCSgweDMgPDwgMjQpCS8qIE1DTEsgRGF0
YSBDYXB0dXJlIERlbGF5IG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjRfUENMS19FTgkoMSA8PCAyMykJ
LyogUGl4ZWwgY2xvY2sgZW5hYmxlICovCi0jZGVmaW5lIENJQ1I0X1BDUAkoMSA8PCAyMikJLyog
UGl4ZWwgY2xvY2sgcG9sYXJpdHkgKi8KLSNkZWZpbmUgQ0lDUjRfSFNQCSgxIDw8IDIxKQkvKiBI
b3Jpem9udGFsIHN5bmMgcG9sYXJpdHkgKi8KLSNkZWZpbmUgQ0lDUjRfVlNQCSgxIDw8IDIwKQkv
KiBWZXJ0aWNhbCBzeW5jIHBvbGFyaXR5ICovCi0jZGVmaW5lIENJQ1I0X01DTEtfRU4JKDEgPDwg
MTkpCS8qIE1DTEsgZW5hYmxlICovCi0jZGVmaW5lIENJQ1I0X0ZSX1JBVEUJKDB4NyA8PCA4KQkv
KiBGcmFtZSByYXRlIG1hc2sgKi8KLSNkZWZpbmUgQ0lDUjRfRElWCSgweGZmIDw8IDApCS8qIENs
b2NrIGRpdmlzb3IgbWFzayAqLwotCi0jZGVmaW5lIENJU1JfRlRPCSgxIDw8IDE1KQkvKiBGSUZP
IHRpbWUtb3V0ICovCi0jZGVmaW5lIENJU1JfUkRBVl8yCSgxIDw8IDE0KQkvKiBDaGFubmVsIDIg
cmVjZWl2ZSBkYXRhIGF2YWlsYWJsZSAqLwotI2RlZmluZSBDSVNSX1JEQVZfMQkoMSA8PCAxMykJ
LyogQ2hhbm5lbCAxIHJlY2VpdmUgZGF0YSBhdmFpbGFibGUgKi8KLSNkZWZpbmUgQ0lTUl9SREFW
XzAJKDEgPDwgMTIpCS8qIENoYW5uZWwgMCByZWNlaXZlIGRhdGEgYXZhaWxhYmxlICovCi0jZGVm
aW5lIENJU1JfRkVNUFRZXzIJKDEgPDwgMTEpCS8qIENoYW5uZWwgMiBGSUZPIGVtcHR5ICovCi0j
ZGVmaW5lIENJU1JfRkVNUFRZXzEJKDEgPDwgMTApCS8qIENoYW5uZWwgMSBGSUZPIGVtcHR5ICov
Ci0jZGVmaW5lIENJU1JfRkVNUFRZXzAJKDEgPDwgOSkJLyogQ2hhbm5lbCAwIEZJRk8gZW1wdHkg
Ki8KLSNkZWZpbmUgQ0lTUl9FT0wJKDEgPDwgOCkJLyogRW5kIG9mIGxpbmUgKi8KLSNkZWZpbmUg
Q0lTUl9QQVJfRVJSCSgxIDw8IDcpCS8qIFBhcml0eSBlcnJvciAqLwotI2RlZmluZSBDSVNSX0NR
RAkoMSA8PCA2KQkvKiBDYW1lcmEgaW50ZXJmYWNlIHF1aWNrIGRpc2FibGUgKi8KLSNkZWZpbmUg
Q0lTUl9DREQJKDEgPDwgNSkJLyogQ2FtZXJhIGludGVyZmFjZSBkaXNhYmxlIGRvbmUgKi8KLSNk
ZWZpbmUgQ0lTUl9TT0YJKDEgPDwgNCkJLyogU3RhcnQgb2YgZnJhbWUgKi8KLSNkZWZpbmUgQ0lT
Ul9FT0YJKDEgPDwgMykJLyogRW5kIG9mIGZyYW1lICovCi0jZGVmaW5lIENJU1JfSUZPXzIJKDEg
PDwgMikJLyogRklGTyBvdmVycnVuIGZvciBDaGFubmVsIDIgKi8KLSNkZWZpbmUgQ0lTUl9JRk9f
MQkoMSA8PCAxKQkvKiBGSUZPIG92ZXJydW4gZm9yIENoYW5uZWwgMSAqLwotI2RlZmluZSBDSVNS
X0lGT18wCSgxIDw8IDApCS8qIEZJRk8gb3ZlcnJ1biBmb3IgQ2hhbm5lbCAwICovCi0KLSNkZWZp
bmUgQ0lGUl9GTFZMMgkoMHg3ZiA8PCAyMykJLyogRklGTyAyIGxldmVsIG1hc2sgKi8KLSNkZWZp
bmUgQ0lGUl9GTFZMMQkoMHg3ZiA8PCAxNikJLyogRklGTyAxIGxldmVsIG1hc2sgKi8KLSNkZWZp
bmUgQ0lGUl9GTFZMMAkoMHhmZiA8PCA4KQkvKiBGSUZPIDAgbGV2ZWwgbWFzayAqLwotI2RlZmlu
ZSBDSUZSX1RITF8wCSgweDMgPDwgNCkJLyogVGhyZXNob2xkIExldmVsIGZvciBDaGFubmVsIDAg
RklGTyAqLwotI2RlZmluZSBDSUZSX1JFU0VUX0YJKDEgPDwgMykJLyogUmVzZXQgaW5wdXQgRklG
T3MgKi8KLSNkZWZpbmUgQ0lGUl9GRU4yCSgxIDw8IDIpCS8qIEZJRk8gZW5hYmxlIGZvciBjaGFu
bmVsIDIgKi8KLSNkZWZpbmUgQ0lGUl9GRU4xCSgxIDw8IDEpCS8qIEZJRk8gZW5hYmxlIGZvciBj
aGFubmVsIDEgKi8KLSNkZWZpbmUgQ0lGUl9GRU4wCSgxIDw8IDApCS8qIEZJRk8gZW5hYmxlIGZv
ciBjaGFubmVsIDAgKi8KLQotLSAKMS42LjAuMgoK
------=_Part_43721_12946444.1227859060206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_43721_12946444.1227859060206--
