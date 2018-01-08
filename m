Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757411AbeAHUlI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 15:41:08 -0500
Date: Mon, 8 Jan 2018 21:40:55 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        <torvalds@linux-foundation.org>
Subject: Re:  Re: dvb usb issues since kernel 4.9
Message-ID: <20180108214055.1945c509@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.1801081227540.1908-100000@iolanthe.rowland.org>
References: <trinity-d42aadc3-e83a-4e22-9c98-011ab0bffcf3-1515431701061@3c-app-gmx-bs43>
        <Pine.LNX.4.44L0.1801081227540.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Jan 2018 12:35:08 -0500 (EST) Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 8 Jan 2018, Josef Griebichler wrote:
> 
> > No I can't sorry. There's no sat connection near to my workstation.  
> 
> Can we ask the person who made this post:
> https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965
> 
> to run the test?  The post says that the testing was done on an x86_64 
> machine.

For >5 years ago I used to play a lot with IPTV multicast MPEG2-TS
streams (I implemented the wireshark mp2ts drop detecting, and a
out-of-tree netfilter kernel module to detect drops[1]). The web-site
is dead, but archive.org have a copy[2].

Let me quote my own Lab-setup documentation[3].

You don't need a live IPTV MPEG2TS signal, you can simply generate your
own using VLC:

 $ vlc ~/Videos/test_video.mkv -I rc --sout '#duplicate{dst=std{access=udp,mux=ts,dst=239.254.1.1:5500}}'

Viewing your own signal: You can view your own generated signal, again,
by using VLC.

 $ vlc udp/ts://@239.254.1.1:5500

I hope the vlc syntax is still valid.  And remember to join the
multicast channels, if you don't have an application requesting the
stream, as desc in [4].


[1] https://github.com/netoptimizer/IPTV-Analyzer
[2] http://web.archive.org/web/20150328200122/http://www.iptv-analyzer.org:80/wiki/index.php/Main_Page
[3] http://web.archive.org/web/20150329095538/http://www.iptv-analyzer.org:80/wiki/index.php/Lab_Setup
[4] http://web.archive.org/web/20150328234459/http://www.iptv-analyzer.org:80/wiki/index.php/Multicast_Signal_on_Linux
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
