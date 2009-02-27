Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1R7jlbH031832
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 02:45:47 -0500
Received: from mail-fx0-f174.google.com (mail-fx0-f174.google.com
	[209.85.220.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1R7jX8v002127
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 02:45:33 -0500
Received: by fxm22 with SMTP id 22so942345fxm.3
	for <video4linux-list@redhat.com>; Thu, 26 Feb 2009 23:45:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b24e53350902261525j5e7cd63dkdba6163f6ca56cae@mail.gmail.com>
References: <b24e53350902261307x7ea7e172na47dc479ac9d25cf@mail.gmail.com>
	<b24e53350902261525j5e7cd63dkdba6163f6ca56cae@mail.gmail.com>
Date: Fri, 27 Feb 2009 08:45:32 +0100
Message-ID: <d9def9db0902262345x3a5ef518udeec2d09da56f2bd@mail.gmail.com>
From: Markus Rechberger <mrechberger@gmail.com>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jerry Geis <geisj@messagenetsystems.com>,
	Kevin Brown <kbrown@messagenetsystems.com>,
	V4L <video4linux-list@redhat.com>
Subject: Re: v4l2: ioctl queue buffer failed: No space left on device
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

On Fri, Feb 27, 2009 at 12:25 AM, Robert Krakora
<rob.krakora@messagenetsystems.com> wrote:
> On Thu, Feb 26, 2009 at 4:07 PM, Robert Krakora
> <rob.krakora@messagenetsystems.com> wrote:
>> All:
>>
>> I have vlc running a v4l2 supported web cam (runs great for both audio
>> and video).  However, when I start up my em28xx based device in analog
>> mode via mplayer I see this message:
>>
>> v4l2: ioctl queue buffer failed: No space left on device
>>
>> I have to take down vlc to start up my em28xx based device in analog
>> mode via mplayer.  I assume there is probably no kmalloc memory
>> available, but I am not for sure as I have not looked at the source
>> yet.
>>
>> Best Regards,
>>
>> --
>> Rob Krakora
>> Senior Software Engineer
>> MessageNet Systems
>> 101 East Carmel Dr. Suite 105
>> Carmel, IN 46032
>> (317)566-1677 Ext. 206
>> (317)663-0808 Fax
>>
>
> All:
>
> It appears as though Markus identified this problem three years ago as
> possibly a bug in the USB stack (see below).  The other device that
> shares the USB bus with the KWorld 330U em28xx device is a VF0560
> Live! Cam Optia AF webcam.  Any suggestions or comments are welcome.
> ;-)
>

try to load the driver with the alt=3 parameter then it should work out.

regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
