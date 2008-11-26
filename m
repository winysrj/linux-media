Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQKR0UU015120
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 15:27:00 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQKQhFp002409
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 15:26:44 -0500
Received: by nf-out-0910.google.com with SMTP id d3so355295nfc.21
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 12:26:43 -0800 (PST)
Message-ID: <412bdbff0811261226l478e3d4eg2f0551239e56540a@mail.gmail.com>
Date: Wed, 26 Nov 2008 15:26:43 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
In-Reply-To: <alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

On Wed, Nov 26, 2008 at 3:00 PM, Kiss Gabor (Bitman)
<kissg@ssg.ki.iif.hu> wrote:
>> Hello Gabor,
>>
>> Playing with the "card=" argument is probably not such a good idea.
>> I should consider taking that functionality out, since setting to the
>> wrong card number can damage the device (by setting the wrong GPIOs).
>>
>> If somebody can get me a USB trace of the device starting up under
>> Windows, I can probably make this card work.
>
> Dear Devin,
>
> We could get two USB traces (some 2-4 GB each uncompressed).
> File http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-tv.rar shows
> what happened during setup and the first few seconds of scanning
> for TV channels. (Unfortunately we had no good antenna signal.)
> http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-svideo.rar is recorded
> during setup and  shor use of S-video input.
>
> And http://bakacsin.ki.iif.hu/~kissg/tmp/connect-UsbSnoop.log.txt
> is the log of USB connection.
>
> I hope this can provide you enough information.
>
> Device is ADS Tech "Instant TV USB"
> http://www.adstech.com/Support/ProductSupport.asp?productId=USBAV-704&productName=Instant%20TV
>
> Regards
>
> Gabor

Hello Gabor,

I hate to admit it, but I got confused since two different people
named "Gabor" have been sending me email in regards to different
em28xx based devices.

Could you please clarify the exact model number of the device in
question?  ADS makes multiple products, some with very similar names
and it is important that I am focusing on the correct product.

Also, you can run the files through the parser.pl that Markus
Rechberger's ships with his very useful "usbreplay" tool.  This will
make them *much* smaller.

Thanks,

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
