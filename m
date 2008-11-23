Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANEEbfB026947
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 09:14:37 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANEEM07030177
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 09:14:23 -0500
Received: by ug-out-1314.google.com with SMTP id j30so544918ugc.13
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 06:14:22 -0800 (PST)
Message-Id: <C76A9A84-CC2C-4384-8B4D-5435DD2D3F57@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1227071437.3117.42.camel@palomino.walls.org>
Content-Type: multipart/mixed; boundary=Apple-Mail-1-34349223
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Sun, 23 Nov 2008 09:14:12 -0500
References: <1227071437.3117.42.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] cx18: Extensive interrupt and buffer handling
	changes need test
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


--Apple-Mail-1-34349223
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On Nov 19, 2008, at 12:10 AM, Andy Walls wrote:

> cx18 driver users:
>
> I have implemented quite a few cx18 driver changes in my current
> experimental repo at
>
> http://linuxtv.org/hg/~awalls/cx18-bugfix
>
> The goal behind these changes is to fix problems with simultaneous
> analog and digital capture causing the driver to quit after a while.
> And to fix related problems with buffers getting lost and falling  
> out of
> the driver<->firmware transfer rotation.
>
> To achieve that result, I had to do extensive rework of how interrupts
> were handled and some buffer handling tweaks.  I'm looking for (brave)
> testers to give this stuff a try, or an inspection, before I ask Mauro
> to pull it.  I also plan to do testing on my other two machines in a  
> day
> or two.
>
> Please test the debug parameter with at least info and warn set:
>
> # modprobe cx18 debug=3
>
>
> I am especially interested in
>
>
> 1. How often you get messages like the following on your system?
>
> cx18-0 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. nnnn)

Andy,

dmesg output attached. Seems to happen frequently.

Brandon


--Apple-Mail-1-34349223
Content-Disposition: attachment;
	filename=dmesg.out.gz
Content-Type: application/x-gzip; x-mac-creator=534D554C; x-unix-mode=0644;
	x-mac-type=534D4C64; name="dmesg.out.gz"
Content-Transfer-Encoding: base64

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
AAA=

--Apple-Mail-1-34349223
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-1-34349223
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Apple-Mail-1-34349223--
