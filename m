Return-path: <video4linux-list-bounces@redhat.com>
MIME-Version: 1.0
In-Reply-To: <49CA8EA3.5040905@redhat.com>
References: <49C27C1B.10705@gmail.com> <49C7D898.3030102@redhat.com>
	<49C93889.8030009@gmail.com> <49C93CB2.4040208@redhat.com>
	<e26aa8c30903251252g609d4d6ela268aed3fe99c490@mail.gmail.com>
	<49CA8EA3.5040905@redhat.com>
Date: Fri, 27 Mar 2009 10:14:31 +0100
Message-ID: <e26aa8c30903270214q4b08dee6t32cb32a966ee8619@mail.gmail.com>
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: webcam doesn't working with programs using libv4l
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

On Wed, Mar 25, 2009 at 9:05 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Ok,
>
> There seems to be an error of some sort of the way munmap is getting called
> by
> gstreamer on the memory buffers, if you look in the log file you will see:
>
> libv4l2: Passing mmap((nil), 2621440, ..., 0, through to the driver
>
> And then later on:
>
> libv4l2: v4l2 unknown munmap 0xf4200000, -2141226112
>
> The unknown munmap message is normal, as the mmap was passed through to the
> driver. But the -2141226112 as size for the buffer to unmap is way off.
>
> This also explains why the uvc driver thinks the device is not closed yet,
> because
> the maps are still active. The device is actually being closed, before its
> re-opened from the log:
>
> libv4l2: close: 23
> libv4l2: open: 25
>
>
> No idea though what is causing the size argument to the munmap to get messed
> up like this.

Hans, thanks for your analysis will try to poke gstreamer devs.

-- 
Riccardo Magliocchetti

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
