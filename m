Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:48989 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750827AbeBWOOg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 09:14:36 -0500
Date: Fri, 23 Feb 2018 22:13:34 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linuxtv-media:fixes 10/11]
 drivers/media/pci/ttpci/av7110_av.c:817:28: sparse: not enough arguments for
 function ts
Message-ID: <201802232230.k2Thc3Dg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git fixes
head:   0e0751a4b9ee82ff086472ab4e81ee693fbe091a
commit: a3938f1b749cbedf47c4cb6af08f1c29e9418007 [10/11] media: dvb: update buffer mmaped flags and frame counter
reproduce:
        # apt-get install sparse
        git checkout a3938f1b749cbedf47c4cb6af08f1c29e9418007
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/ttpci/av7110_av.c:817:28: sparse: not enough arguments for function ts
   drivers/media/pci/ttpci/av7110_av.c:101:41: sparse: not enough arguments for function ts
   drivers/media/pci/ttpci/av7110_av.c:111:26: sparse: not enough arguments for function ts
   drivers/media/pci/ttpci/av7110_av.c: In function 'av7110_record_cb':
   drivers/media/pci/ttpci/av7110_av.c:101:10: error: too few arguments to function 'dvbdmxfeed->cb.ts'
    return dvbdmxfeed->cb.ts(buf, len, NULL, 0,
    ^~~~~~~~~~
   drivers/media/pci/ttpci/av7110_av.c: In function 'dvb_filter_pes2ts_cb':
   drivers/media/pci/ttpci/av7110_av.c:111:2: error: too few arguments to function 'dvbdmxfeed->cb.ts'
    dvbdmxfeed->cb.ts(data, 188, NULL, 0,
    ^~~~~~~~~~
   drivers/media/pci/ttpci/av7110_av.c: In function 'p_to_t':
   drivers/media/pci/ttpci/av7110_av.c:817:3: error: too few arguments to function 'feed->cb.ts'
    feed->cb.ts(obuf, 188, NULL, 0, &feed->feed.ts);
    ^~~~
   drivers/media/pci/ttpci/av7110_av.c: In function 'av7110_record_cb':
   drivers/media/pci/ttpci/av7110_av.c:105:1: warning: control reaches end of non-void function
    }
    ^
--
>> drivers/media/pci/ttpci/av7110.c:325:50: sparse: not enough arguments for function sec
>> drivers/media/pci/ttpci/av7110.c:332:57: sparse: not enough arguments for function ts
   drivers/media/pci/ttpci/av7110.c: In function 'DvbDmxFilterCallback':
   drivers/media/pci/ttpci/av7110.c:325:10: error: too few arguments to function 'dvbdmxfilter->feed->cb.sec'
    return dvbdmxfilter->feed->cb.sec(buffer1, buffer1_len,
    ^~~~~~~~~~~~
   drivers/media/pci/ttpci/av7110.c:332:11: error: too few arguments to function 'dvbdmxfilter->feed->cb.ts'
    return dvbdmxfilter->feed->cb.ts(buffer1, buffer1_len,
    ^~~~~~~~~~~~

vim +817 drivers/media/pci/ttpci/av7110_av.c

^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  773  
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  774  
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  775  static void p_to_t(u8 const *buf, long int length, u16 pid, u8 *counter,
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  776  		   struct dvb_demux_feed *feed)
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  777  {
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  778  	int l, pes_start;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  779  	u8 obuf[TS_SIZE];
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  780  	long c = 0;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  781  
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  782  	pes_start = 0;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  783  	if (length > 3 &&
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  784  	     buf[0] == 0x00 && buf[1] == 0x00 && buf[2] == 0x01)
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  785  		switch (buf[3]) {
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  786  			case PROG_STREAM_MAP:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  787  			case PRIVATE_STREAM2:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  788  			case PROG_STREAM_DIR:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  789  			case ECM_STREAM     :
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  790  			case EMM_STREAM     :
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  791  			case PADDING_STREAM :
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  792  			case DSM_CC_STREAM  :
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  793  			case ISO13522_STREAM:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  794  			case PRIVATE_STREAM1:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  795  			case AUDIO_STREAM_S ... AUDIO_STREAM_E:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  796  			case VIDEO_STREAM_S ... VIDEO_STREAM_E:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  797  				pes_start = 1;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  798  				break;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  799  
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  800  			default:
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  801  				break;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  802  		}
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  803  
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  804  	while (c < length) {
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  805  		memset(obuf, 0, TS_SIZE);
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  806  		if (length - c >= (TS_SIZE - 4)){
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  807  			l = write_ts_header2(pid, counter, pes_start,
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  808  					     obuf, (TS_SIZE - 4));
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  809  			memcpy(obuf + l, buf + c, TS_SIZE - l);
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  810  			c += TS_SIZE - l;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  811  		} else {
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  812  			l = write_ts_header2(pid, counter, pes_start,
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  813  					     obuf, length - c);
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  814  			memcpy(obuf + l, buf + c, TS_SIZE - l);
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  815  			c = length;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  816  		}
2f684b23 drivers/media/pci/ttpci/av7110_av.c Mauro Carvalho Chehab 2015-10-06 @817  		feed->cb.ts(obuf, 188, NULL, 0, &feed->feed.ts);
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  818  		pes_start = 0;
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  819  	}
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  820  }
^1da177e drivers/media/dvb/ttpci/av7110_av.c Linus Torvalds        2005-04-16  821  

:::::: The code at line 817 was first introduced by commit
:::::: 2f684b239cdbfcc1160392645a8fc056a68847ca [media] dvb: get rid of enum dmx_success

:::::: TO: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
