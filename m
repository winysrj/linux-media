Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33231 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbbERQAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 12:00:19 -0400
Received: by qcvo8 with SMTP id o8so91521382qcv.0
        for <linux-media@vger.kernel.org>; Mon, 18 May 2015 09:00:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bug-98541-41252@https.bugzilla.kernel.org/>
References: <bug-98541-41252@https.bugzilla.kernel.org/>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 18 May 2015 10:59:57 -0500
Message-ID: <CAErSpo5iKKUBoTni4EMLLejuxVWeKY=r+XmC_wa2e777mZQ+oA@mail.gmail.com>
Subject: Fwd: [Bug 98541] New: there exists a wrong return value of function meye_probe()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---------- Forwarded message ----------
From:  <bugzilla-daemon@bugzilla.kernel.org>
Date: Mon, May 18, 2015 at 3:19 AM
Subject: [Bug 98541] New: there exists a wrong return value of
function meye_probe()
To: bhelgaas@google.com


https://bugzilla.kernel.org/show_bug.cgi?id=98541

            Bug ID: 98541
           Summary: there exists a wrong return value of function
                    meye_probe()
           Product: Drivers
           Version: 2.5
    Kernel Version: 3.19.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: PCI
          Assignee: drivers_pci@kernel-bugs.osdl.org
          Reporter: rucsoftsec@gmail.com
        Regression: No

In function meye_probe() at drivers/media/pci/meye/meye.c:1592, the call to
video_register_device() in line 1748 may return a negative error code, and thus
function meye_probe() will return the value of variable ret. And, the function
meye_probe() will return 0 at last when it runs well. However, when the call to
video_register_device() in line 1748 return a negative error code, the value of
ret is 0. So the function meye_probe() will return 0 to its caller functions
when it runs error because of the failing call to video_register_device(),
leading to a wrong return value of function meye_probe().
The related code snippets in meye_probe() is as following.
meye_probe @@ drivers/media/pci/meye/meye.c:1592
1592static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id
*ent)
1593{
            ...
1672        if ((ret = pci_enable_device(meye.mchip_dev))) {
1673                v4l2_err(v4l2_dev, "meye: pci_enable_device failed\n");
1674                goto outenabledev;
1675        }
            ...
1748        if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
1749                                  video_nr) < 0) {
1750                v4l2_err(v4l2_dev, "video_register_device failed\n");
1751                goto outvideoreg;
1752        }
            ...
1761outvideoreg:
            ...
1781outnotdev:
1782        return ret;
1783}

Generally, when the call to video_register_device() fails, the return value of
caller functions should be different from another return value set when the
call to video_register_device() succeeds, like the following codes in another
file.
cx8800_initdev @@ drivers/media/pci/cx88/cx88-video.c:1300
1300static int cx8800_initdev(struct pci_dev *pci_dev,
1301                          const struct pci_device_id *pci_id)
1302{
            ...
1493        err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
1494                                    video_nr[core->nr]);
1495        if (err < 0) {
1496                printk(KERN_ERR "%s/0: can't register video device\n",
1497                       core->name);
1498                goto fail_unreg;
1499        }
            ...
1545fail_unreg:
1546        cx8800_unregister_video(dev);
1547        free_irq(pci_dev->irq, dev);
1548        mutex_unlock(&core->lock);
1549fail_core:
1550        vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
1551        core->v4ldev = NULL;
1552        cx88_core_put(core,dev->pci);
1553fail_free:
1554        kfree(dev);
1555        return err;
1556}

Thank you

RUC_Soft_Sec

--
You are receiving this mail because:
You are watching the assignee of the bug.
