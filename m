Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:46785 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751032AbdGOPQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 11:16:32 -0400
Date: Sat, 15 Jul 2017 17:16:29 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Philipp Zabel <philipp.zabel@gmail.com>
cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, kbuild-all@01.org
Subject: Re: [PATCH 1/3] [media] uvcvideo: variable size controls (fwd)
Message-ID: <alpine.DEB.2.20.1707151714530.2468@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a double free on data if the goto is taken on line 1815.

julia

---------- Forwarded message ----------
Date: Sat, 15 Jul 2017 21:07:03 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] [media] uvcvideo: variable size controls

CC: kbuild-all@01.org
In-Reply-To: <20170714201424.23592-1-philipp.zabel@gmail.com>
TO: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-media@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Philipp Zabel <philipp.zabel@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Philipp Zabel <philipp.zabel@gmail.com>

Hi Philipp,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.12 next-20170714]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Philipp-Zabel/uvcvideo-variable-size-controls/20170715-193137
base:   git://linuxtv.org/media_tree.git master
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> drivers/media/usb/uvc/uvc_ctrl.c:1857:7-11: ERROR: reference preceded by free on line 1809

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout f06e94cde314fba5859cd6c999dde48e94156c7a
vim +1857 drivers/media/usb/uvc/uvc_ctrl.c

52c58ad6f drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-09-29  1719
8e113595e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2009-07-01  1720  int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1721  	struct uvc_xu_control_query *xqry)
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1722  {
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1723  	struct uvc_entity *entity;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1724  	struct uvc_control *ctrl;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1725  	unsigned int i, found = 0;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1726  	__u32 reqflags;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1727  	__u16 size;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1728  	__u8 *data = NULL;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1729  	int ret;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1730
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1731  	/* Find the extension unit. */
6241d8ca1 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2009-11-25  1732  	list_for_each_entry(entity, &chain->entities, chain) {
6241d8ca1 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2009-11-25  1733  		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT &&
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1734  		    entity->id == xqry->unit)
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1735  			break;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1736  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1737
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1738  	if (entity->id != xqry->unit) {
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1739  		uvc_trace(UVC_TRACE_CONTROL, "Extension unit %u not found.\n",
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1740  			xqry->unit);
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1741  		return -ENOENT;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1742  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1743
52c58ad6f drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-09-29  1744  	/* Find the control and perform delayed initialization if needed. */
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1745  	for (i = 0; i < entity->ncontrols; ++i) {
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1746  		ctrl = &entity->controls[i];
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1747  		if (ctrl->index == xqry->selector - 1) {
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1748  			found = 1;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1749  			break;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1750  		}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1751  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1752
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1753  	if (!found) {
36bd883ef drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-01-19  1754  		uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u not found.\n",
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1755  			entity->extension.guidExtensionCode, xqry->selector);
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1756  		return -ENOENT;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1757  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1758
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1759  	if (mutex_lock_interruptible(&chain->ctrl_mutex))
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1760  		return -ERESTARTSYS;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1761
52c58ad6f drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-09-29  1762  	ret = uvc_ctrl_init_xu_ctrl(chain->dev, ctrl);
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1763  	if (ret < 0) {
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1764  		ret = -ENOENT;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1765  		goto done;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1766  	}
52c58ad6f drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-09-29  1767
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1768  	/* Validate the required buffer size and flags for the request */
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1769  	reqflags = 0;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1770  	size = ctrl->info.size;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1771
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1772  	switch (xqry->query) {
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1773  	case UVC_GET_CUR:
9eb30d2fa drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-11-21  1774  		reqflags = UVC_CTRL_FLAG_GET_CUR;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1775  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1776  	case UVC_GET_MIN:
9eb30d2fa drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-11-21  1777  		reqflags = UVC_CTRL_FLAG_GET_MIN;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1778  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1779  	case UVC_GET_MAX:
9eb30d2fa drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-11-21  1780  		reqflags = UVC_CTRL_FLAG_GET_MAX;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1781  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1782  	case UVC_GET_DEF:
9eb30d2fa drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-11-21  1783  		reqflags = UVC_CTRL_FLAG_GET_DEF;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1784  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1785  	case UVC_GET_RES:
9eb30d2fa drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-11-21  1786  		reqflags = UVC_CTRL_FLAG_GET_RES;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1787  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1788  	case UVC_SET_CUR:
9eb30d2fa drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-11-21  1789  		reqflags = UVC_CTRL_FLAG_SET_CUR;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1790  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1791  	case UVC_GET_LEN:
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1792  		size = 2;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1793  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1794  	case UVC_GET_INFO:
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1795  		size = 1;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1796  		break;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1797  	default:
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1798  		ret = -EINVAL;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1799  		goto done;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1800  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1801
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1802  	if ((ctrl->info.flags & UVC_CTRL_FLAG_VARIABLE_LEN) && reqflags) {
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1803  		data = kmalloc(2, GFP_KERNEL);
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1804  		/* Check if the control length has changed */
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1805  		ret = uvc_query_ctrl(chain->dev, UVC_GET_LEN, xqry->unit,
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1806  				     chain->dev->intfnum, xqry->selector, data,
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1807  				     2);
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1808  		size = le16_to_cpup((__le16 *)data);
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14 @1809  		kfree(data);
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1810  		if (ret < 0) {
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1811  			uvc_trace(UVC_TRACE_CONTROL,
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1812  				  "GET_LEN failed on control %pUl/%u (%d).\n",
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1813  				  entity->extension.guidExtensionCode,
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1814  				  xqry->selector, ret);
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1815  			goto done;
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1816  		}
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1817  		if (ctrl->info.size != size) {
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1818  			uvc_trace(UVC_TRACE_CONTROL,
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1819  				  "XU control %pUl/%u queried: len %u -> %u\n",
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1820  				  entity->extension.guidExtensionCode,
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1821  				  xqry->selector, ctrl->info.size, size);
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1822  			ctrl->info.size = size;
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1823  		}
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1824  	}
f06e94cde drivers/media/usb/uvc/uvc_ctrl.c   Philipp Zabel    2017-07-14  1825
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1826  	if (size != xqry->size) {
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1827  		ret = -ENOBUFS;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1828  		goto done;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1829  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1830
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1831  	if (reqflags && !(ctrl->info.flags & reqflags)) {
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1832  		ret = -EBADRQC;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1833  		goto done;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1834  	}
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1835
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1836  	data = kmalloc(size, GFP_KERNEL);
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1837  	if (data == NULL) {
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1838  		ret = -ENOMEM;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1839  		goto done;
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1840  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1841
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1842  	if (xqry->query == UVC_SET_CUR &&
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1843  	    copy_from_user(data, xqry->data, size)) {
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1844  		ret = -EFAULT;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1845  		goto done;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1846  	}
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1847
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1848  	ret = uvc_query_ctrl(chain->dev, xqry->query, xqry->unit,
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1849  			     chain->dev->intfnum, xqry->selector, data, size);
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1850  	if (ret < 0)
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1851  		goto done;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1852
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1853  	if (xqry->query != UVC_SET_CUR &&
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02  1854  	    copy_to_user(xqry->data, data, size))
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1855  		ret = -EFAULT;
27a61c13e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2010-10-02  1856  done:
fe78d187f drivers/media/video/uvc/uvc_ctrl.c Martin Rubli     2010-10-02 @1857  	kfree(data);
8e113595e drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2009-07-01  1858  	mutex_unlock(&chain->ctrl_mutex);
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1859  	return ret;
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1860  }
c0efd2329 drivers/media/video/uvc/uvc_ctrl.c Laurent Pinchart 2008-06-30  1861

:::::: The code at line 1857 was first introduced by commit
:::::: fe78d187fe792fac5d190b19a2806c23df28891e [media] uvcvideo: Add UVCIOC_CTRL_QUERY ioctl

:::::: TO: Martin Rubli <martin_rubli@logitech.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
