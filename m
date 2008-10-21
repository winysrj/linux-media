Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9L97axx015853
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 05:07:36 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9L97L2D012646
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 05:07:21 -0400
Message-ID: <48FD9C85.5040102@hhs.nl>
Date: Tue, 21 Oct 2008 11:10:29 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
References: <bug-11776-10286@http.bugzilla.kernel.org/>
	<20081020165537.9bb9ae8a.akpm@linux-foundation.org>
In-Reply-To: <20081020165537.9bb9ae8a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linuxkernel@lanrules.de,
	bugme-daemon@bugzilla.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Bugme-new] [Bug 11776] New: Regression: Hardware working with
 old stock gspca module fails with 2.6.27 module
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

Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> gspca doesn't seem to have a MAINTAINERS record.  Or it is entered
> under something unobvious so my search failed?
> 

We need to fix that then, gspca is maintained by Jean-Francois Moine, with me 
co-maintaining.

<snip>

>> This is the information about the webcam given by the old gspca module, still
>> working with 2.6.26:
>> Camera found: lenovo MI1310_SOC
>> Bridge found: VC0323
>> StreamId: JPEG Camera
>> quality 7 autoexpo 1 Timeframe 0 lightfreq 50
>> Available Resolutions width 640  heigth 480 native
>> Available Resolutions width 352  heigth 288 native
>> Available Resolutions width 320  heigth 240 native *
>> Available Resolutions width 176  heigth 144 native
>> Available Resolutions width 160  heigth 120 native
>> unable to probe size !! 
>>

Ok, so from this I gather that you are using spcaview to watch images from the 
cam. spcaview by default asks the driver for yv12 format video data.

However the vc0323 cam in your laptop delivers video data in JPEG format. The 
old gspca driver did format conversion inside the kernel. Which is a very bad 
thing to do and thus has been removed in the new version.

Most apps / libraries do not know how to handle the multitude of video formats 
webcams can produce. For this I've written libv4l:
http://hansdegoede.livejournal.com/3636.html

Get the latest version here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.1.tar.gz

Then read:
http://moinejf.free.fr/gspca_README.txt
or the included README for install instructions.

As described in the documents you can make existing applications use this lib 
with an LD_PRELOAD loadable wrapper.

FOSS applications can be easily adapted to instead use the library directly, a 
coordinated cross distro effort is underway to make this happen (including 
pushing patches upstream), see:
http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress

You can find patches for quite a few applications here. Help in patching others 
is very much welcome! If you need some quick instructions what to change 
exactly let me know.

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
