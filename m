Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdLUMsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 07:48:08 -0500
Date: Thu, 21 Dec 2017 10:47:56 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Satendra Singh Thakur <satendra.t@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        pombredanne@nexb.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, madhur.verma@samsung.com,
        hemanshu.s@samsung.com, sst2005@gmail.com,
        kstewart@linuxfoundation.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, keescook@chromium.org,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>
Subject: Re: [PATCH v1] media: videobuf2: Add new uAPI for DVB streaming I/O
Message-ID: <20171221104756.18570f89@vento.lan>
In-Reply-To: <1513654553-27097-1-git-send-email-satendra.t@samsung.com>
References: <CGME20171219033612epcas5p41cb7d88255e0677d00c7e79572d27bc7@epcas5p4.samsung.com>
        <1513654553-27097-1-git-send-email-satendra.t@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Dec 2017 09:05:53 +0530
Satendra Singh Thakur <satendra.t@samsung.com> escreveu:

> -Ported below mentioned patch to latest kernel:
>  commit ace52288edf0 ("Merge tag 'for-linus-20171218' of
>  git://git.infradead.org/linux-mtd")
> 
> -Fixed few bugs in the patch, enhanced it and added polling
> --dvb_vb2.c:dvb_vb2_fill_buffer=>  
> ----Set the size of the outgoing buffer after while loop using
>  vb2_set_plane_payload
> ----Added NULL check for source buffer as per normal convention of
>  demux driver, this is called twice, first time with valid buffer
>  second time with NULL pointer, if its not handled, it will result in
>  crash
> ---Restricted spinlock for only list_* operations
> 
> --dvb_vb2.c:dvb_vb2_init=>  
> ----Restricted q->io_modes to only VB2_MMAP as its the only
>  supported mode
> 
> --dvb_vb2.c:dvb_vb2_release=>Replaced the && in if condiion with &,  
>  because it was always getting satisfied.
> 
> --dvb_vb2.c:dvb_vb2_stream_off=>Added list_del code for enqueud buffers  
>  upon stream off
> 
> -Added polling functionality
> --dvb_vb2.c:dvb_vb2_poll=>added this function  
> --dmxdev.c:dvb_demux_poll, dvb_dvr_poll=>Called dvb_vb2_poll from
>  these functions
> 
> -Ported this patch and latest videobuf2 to lower kernel versions and
>  tested auto scan
> 
> -Original patch=>
> --https://patchwork.linuxtv.org/patch/31613/
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>

Thanks for the patch!

I applied it on the top of Kernel 4.14 and fixed one bug that were causing 
an annoying WARN_ON() print.

Btw, as you wrote a poll() function, I suspect that you used some app to
test it. Care to ship the patches for your test application?

-

For now, I added on my experimental repository:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb_mmap

I also applied the testing patch from 2015 on this tree:
	https://git.linuxtv.org/mchehab/experimental-v4l-utils.git/log/?h=dvb_mmap

I ended by rewriting the patch description to make it clearer/more
complete.

And I took some statistics using "perf stats" command, using a DiBcom 8000
ISDB-T device (Prolink Microsystems Corp. PV-D231U(RN)-F), running on an
Intel NUC D53427RKE with an i5-3427U CPU @ 1.80GHz (2 cores, 2 threads/core),
equipped with SSD disks.

Those are the results:

1) Writing to a file, using read() syscalls

 Performance counter stats for 'dvbv5-zap -c /home/mchehab/dvb_channel.conf TV Brasilia RedeTV! -o /tmp/out -t120':

     117.253780  task-clock-msecs         #      0.001 CPUs 
           4593  context-switches         #      0.039 M/sec
            425  CPU-migrations           #      0.004 M/sec
            194  page-faults              #      0.002 M/sec
      284427111  cycles                   #   2425.739 M/sec
      143947266  instructions             #      0.506 IPC  
       11975002  cache-references         #    102.129 M/sec
        3571404  cache-misses             #     30.459 M/sec

  120.114989264  seconds time elapsed

2) Writing to a file, using mmap() syscalls

 Performance counter stats for 'dvbv5-zap -c /home/mchehab/dvb_channel.conf TV Brasilia RedeTV! -o /tmp/out -t120 -R':

      69.258796  task-clock-msecs         #      0.001 CPUs 
            999  context-switches         #      0.014 M/sec
            190  CPU-migrations           #      0.003 M/sec
            182  page-faults              #      0.003 M/sec
      176921677  cycles                   #   2554.501 M/sec
      125926300  instructions             #      0.712 IPC  
        5053616  cache-references         #     72.967 M/sec
        3123259  cache-misses             #     45.095 M/sec

  120.235712497  seconds time elapsed

All performance indicators reduced. The most impressive ones are
the number of context switches, that reduced by about 4.5x, and the 
number of cache references by about 2,5x! 

3) Writing to /dev/null, using read() syscalls

 Performance counter stats for 'dvbv5-zap -c /home/mchehab/dvb_channel.conf TV Brasilia RedeTV! -o /dev/null -t120':

      67.633678  task-clock-msecs         #      0.001 CPUs 
           4583  context-switches         #      0.068 M/sec
            113  CPU-migrations           #      0.002 M/sec
            199  page-faults              #      0.003 M/sec
      152635399  cycles                   #   2256.796 M/sec
       30920291  instructions             #      0.203 IPC  
        6273962  cache-references         #     92.764 M/sec
        1666393  cache-misses             #     24.639 M/sec


4) writing to /dev/null, using mmap() syscalls

 Performance counter stats for 'dvbv5-zap -c /home/mchehab/dvb_channel.conf TV Brasilia RedeTV! -o /dev/null -t120 -R':

      19.198192  task-clock-msecs         #      0.000 CPUs 
            991  context-switches         #      0.052 M/sec
            196  CPU-migrations           #      0.010 M/sec
            181  page-faults              #      0.009 M/sec
       44730100  cycles                   #   2329.912 M/sec
       16348743  instructions             #      0.365 IPC  
         794952  cache-references         #     41.408 M/sec
         348873  cache-misses             #     18.172 M/sec

  120.169979970  seconds time elapsed

Here, the gains are even more expressive:
	- the number of task clocks reduced by 3,5 times;
	- the number of context switches reduced by about 4,5 times;
	- the number of CPU cycles reduced by almost 3,5 times;
	- the number of executed instructions reduced almost 2 times;
	- the number of cache references reduced by almost 8 times;
	- the number of cache misses reduced more than 4,5 times.

There was a small penalty to pay: the number of CPU migrations 
increased by about 3/4, but that's explainable by the fact that
now, the CPU usage is a lot less, and the scheduler optimized the
code to use more CPUs.

In summary, from what I tested so far, the results are impressive,
even considering that I tested with an USB device!

I'll keep running more tests here and preparing this patchset to be
merged upstream.

Thanks,
Mauro
