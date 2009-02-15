Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1FMJiiC009941
	for <video4linux-list@redhat.com>; Sun, 15 Feb 2009 17:19:44 -0500
Received: from smtp111.rog.mail.re2.yahoo.com (smtp111.rog.mail.re2.yahoo.com
	[206.190.37.1])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n1FMJUfZ031331
	for <video4linux-list@redhat.com>; Sun, 15 Feb 2009 17:19:30 -0500
Message-ID: <499894F2.7050703@rogers.com>
Date: Sun, 15 Feb 2009 17:19:30 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: "Chris S. Wilson" <info@coolcatpc.com>
References: <000301c98983$d0d1c7e0$727557a0$@com>
In-Reply-To: <000301c98983$d0d1c7e0$727557a0$@com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: New Card - BT878
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

Chris S. Wilson wrote:
> Hello Everyone, I got a new BT878 card instead of my ATI, I cant seem to get
> it to work:
>  
>
> LSPCI shows me:
>
> ...
>
> 01:05.0 Multimedia video controller: Brooktree Corporation Bt879(??) Video
> Capture (rev 11)
>
> 01:05.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
> (rev 11)
>
> Then I modprobe bttv, and lsmod:
>
> ...
>  
>
> [root@server-1 ~]# lsmod |grep bttv
>
> bttv                  150868  1 bt878
>
> videodev               32000  3 bttv,ivtv,cx88xx
>
> ir_common              38532  2 bttv,cx88xx
>
> compat_ioctl32          5120  2 bttv,ivtv
>
> i2c_algo_bit            8836  3 bttv,ivtv,cx88xx
>
> v4l2_common            12800  3 bttv,ivtv,cx2341x
>
> videobuf_dma_sg        13828  2 bttv,cx88xx
>
> videobuf_core          18052  3 bttv,cx88xx,videobuf_dma_sg
>
> btcx_risc               7560  2 bttv,cx88xx
>
> tveeprom               14596  3 bttv,ivtv,cx88xx
>
> i2c_core               21396  8
> bttv,ivtv,cx88xx,i2c_algo_bit,v4l2_common,tveeprom,nvidia,i2c_nforce2
>
> [root@server-1 ~]#
>
>  
>
> I get no /dev/video0 like I did with this card on my centos 5.1 box, I am
> running Fedora Core 10 on this machine with kernel 2.6.27, any ideas anyone?
> I tried a ./MAKEDEV video0 however this did not fix the issue.
>  
>
> I've browsed around the wiki, read the docs, but cant seem to find any
> answers. Any help would be greatly appreciated.
>   

Chris, what output do you get for: lspci -s 01:05.0 -vnn

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
