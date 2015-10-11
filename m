Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbbJKAzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 20:55:03 -0400
Date: Sun, 11 Oct 2015 08:55:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCHv5 10/13] hackrf: add support for transmitter
Message-ID: <201510110807.WZHKJhfM%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1444495869-1969-11-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Antti,

[auto build test WARNING on linuxtv-media/master -- if it's inappropriate base, please ignore]

config: i386-randconfig-i1-201541 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers/media/usb/hackrf/hackrf.c: In function 'hackrf_buf_queue':
>> drivers/media/usb/hackrf/hackrf.c:777:24: warning: unused variable 'intf' [-Wunused-variable]
     struct usb_interface *intf = dev->intf;
                           ^

vim +/intf +777 drivers/media/usb/hackrf/hackrf.c

   761	
   762		/* Need at least 8 buffers */
   763		if (vq->num_buffers + *nbuffers < 8)
   764			*nbuffers = 8 - vq->num_buffers;
   765		*nplanes = 1;
   766		sizes[0] = PAGE_ALIGN(dev->buffersize);
   767	
   768		dev_dbg(dev->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
   769		return 0;
   770	}
   771	
   772	static void hackrf_buf_queue(struct vb2_buffer *vb)
   773	{
   774		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
   775		struct vb2_queue *vq = vb->vb2_queue;
   776		struct hackrf_dev *dev = vb2_get_drv_priv(vq);
 > 777		struct usb_interface *intf = dev->intf;
   778		struct hackrf_buffer *buffer = container_of(vbuf, struct hackrf_buffer, vb);
   779		struct list_head *buffer_list;
   780		unsigned long flags;
   781	
   782		dev_dbg_ratelimited(&intf->dev, "\n");
   783	
   784		if (vq->type == V4L2_BUF_TYPE_SDR_CAPTURE)
   785			buffer_list = &dev->rx_buffer_list;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--bg08WKrSYDhXBjb5
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
qqnNY3aoh6P+7jOaWOp7CCpPJBb4RD8byteOu6l3sykBAqzZXYZEeeJfX86P773qfDkLsaA3
Pz7+5/VyfNGyrYlSmrghqqggqEwT9KDWkKO3pla7izUEJwGej4YyIZmTbsYoC3qOm5U3BCa8
isT1yCpmNN8Q0OIkEPAk9lxFAe1j8ohDRQWMDvWcvi6YZP6WJJlHMTKHeHx7Wedv1+PT4/VZ
+r5/PT/2WDpnWgYoyFbwbFQhJwuSlznzbOApsPgWLHA3NBqxTBk8e24kxjTwPnY/b5Mmu/f4
75eP89fvL4/4BpRyDHbsE+K277yqijAnEkZHSu9OzQG8A5r2TEyPqA4+g1oZTKWKx2g5SjLK
cgcoMIjvdjuzJgU0tUWrOsS0c6FxE0uK0BbEDJxPnIJmuveNDt6gNovOp50Bsi8se4A3RHzp
e4DmPk4LT6QMDryeDO/oR1XiB9ANkamUoaQmM1iTT4hCJr6uHK2TjV7rLBKgVSrz4Rk1IdC/
sdl8N+67sbhmFfsq9L2fI9A1F5LncDjegbeHuFH6CYtqMr4beB6h0Qhs5zuruZvmEyRJb6y2
I40bWFbyhzxjN3uwTWfDwc7jIdj6QHQfSecWYSlWO8QCnwfd5Elt5JrvCCBz/hotWFm1TnV1
dEcDlxO8m+hUnSWg6wXyhFt9bzzpHXjDBGxWZlJMZ5RkZdLM7gJqnH+AR6HKmkPUjjskGFES
dBpHnLVJnZ815vx8ejofe4/XtxOl+ZPlQpaCDU0Vp5ceCaVT/KHe/AJtxJfiJp54iA1STDCm
paQ2BxWVPlQZuhhMC30wYkgkaDNKDAcLCWXR5kamU0kj92fKM3jQVNyOSTcDJJ2vF4HlEtvB
IeV4UVEY9Xp1p0SEJXNO0TK0qhYAGffS7RXIuY2+Q7Tkg3gnNsiYU3CW6yZVXVi/fsi0Aaev
55fTU+/t+HS+otbIceqQbtniS9Q8lKSvdXhfLkxYWvFgbEq8sg+YNNbdM7IzchOLXqRp+Dvc
KHvHp+Or+Wi43FAsYkVtpNKU8Dpm4+lY066q/cdH07527uNMSJg+xS3tgPrOcVzlTNdfoLNo
NS/dWoTszZ3kemY7Qqi7J5oHMH2UoPN6HHveuwJsycBjLqMPCey/YJGuJ48rEm2TQTD70Vuk
aq/2fhNXe3y59m9GRolRorqNWXXd0DVFF+7lI6ptOjbjczi+PJ4vl+Pbz+bD6P328f1F/P/v
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

--bg08WKrSYDhXBjb5--
