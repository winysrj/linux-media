Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35633 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdJQSSS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 14:18:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kernel test robot <xiaolong.ye@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        lkp@01.org
Subject: Re: [lkp-robot] [uvcvideo]  c698cbbd35: Failed to query (GET_INFO) UVC control 11 on unit 1: -32 (exp. 1).
Date: Tue, 17 Oct 2017 21:18:36 +0300
Message-ID: <1534341.cxAt6LBOsY@avalon>
In-Reply-To: <20170808021846.GK25554@yexl-desktop>
References: <20170808021846.GK25554@yexl-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I think this problem needs to be handled before merging the patch.

On Tuesday, 8 August 2017 05:18:46 EEST kernel test robot wrote:
> FYI, we noticed the following commit:
> 
> commit: c698cbbd35daebf58ced376bb6f98dd013e6cf9e ("uvcvideo: send a control
> event when a Control Change interrupt arrives") url:
> https://github.com/0day-ci/linux/commits/Guennadi-Liakhovetski/UVC-fix-queu
> e_setup-to-check-the-number-of-planes/20170730-123108 base:
> git://linuxtv.org/media_tree.git master
> 
> in testcase: netperf
> with following parameters:
> 
> 	ip: ipv4
> 	runtime: 300s
> 	nr_threads: 200%
> 	cluster: cs-localhost
> 	test: SCTP_STREAM
> 	cpufreq_governor: performance
> 
> test-description: Netperf is a benchmark that can be use to measure various
> aspect of networking performance. test-url: http://www.netperf.org/netperf/
> 
> 
> on test machine: 4 threads Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz with 4G
> memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire
> log/backtrace):
> 
> 
> [   74.743574] uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (5986:0295)
> [   74.744636] uvcvideo: Failed to query (GET_INFO) UVC control 11 on unit
> 1: -32 (exp. 1). [   74.745523] input: Ideapad extra buttons as
> /devices/pci0000:00/0000:00:1f.0/PNP0C09:00/VPC2004:00/input/input15 [  
> 74.746246] uvcvideo: Failed to query (GET_INFO) UVC control 13 on unit 1:
> -32 (exp. 1).
> 
> 
> 
> To reproduce:
> 
>         git clone https://github.com/01org/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install job.yaml  # job file is attached in this email
>         bin/lkp run     job.yaml
> 
> 
> 
> Thanks,
> Xiaolong


-- 
Regards,

Laurent Pinchart
