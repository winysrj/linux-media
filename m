Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55471 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbcKHFyo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 00:54:44 -0500
From: Ravikant Bijendra Sharma <ravikant.s2@samsung.com>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=83=C2=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        =?UTF-8?q?Nils=20Wallm=C3=83=C2=A9nius?=
        <nils.wallmenius@gmail.com>, Jammy Zhou <Jammy.Zhou@amd.com>,
        "monk.liu" <Monk.Liu@amd.com>,
        Ravikant B Sharma <ravikant.s2@samsung.com>,
        Edward O'Callaghan <funfunctor@folklore1984.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Nicolai=20H=C3=83=C2=A4hnle?= <nicolai.haehnle@amd.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Junwei Zhang <Jerry.Zhang@amd.com>,
        Tom St Denis <tom.stdenis@amd.com>,
        Chunming Zhou <David1.Zhou@amd.com>,
        Ken Wang <Qingqing.Wang@amd.com>,
        Flora Cui <Flora.Cui@amd.com>,
        Eric Huang <JinHuiEric.Huang@amd.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        shailesh pandey <p.shailesh@samsung.com>,
        linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Subject: [PATCH] drm/amd/amdgpu : Fix NULL pointer comparison
Date: Tue, 08 Nov 2016 11:19:42 +0530
Message-id: <1478584182-3901-1-git-send-email-ravikant.s2@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ravikant B Sharma <ravikant.s2@samsung.com>

Replace direct comparisons to NULL i.e.
'x == NULL' with '!x'. As per coding standard.

Signed-off-by: Ravikant B Sharma <ravikant.s2@samsung.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c   |    3 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c    |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 2b6afe1..b7e2762 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -70,7 +70,7 @@ static bool igp_read_bios_from_vram(struct amdgpu_device *adev)
 		return false;
 	}
 	adev->bios = kmalloc(size, GFP_KERNEL);
-	if (adev->bios == NULL) {
+	if (!adev->bios) {
 		iounmap(bios);
 		return false;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c
index d8af37a..3ecb083 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c
@@ -327,9 +327,8 @@ int amdgpu_sa_bo_new(struct amdgpu_sa_manager *sa_manager,
 		return -EINVAL;
 
 	*sa_bo = kmalloc(sizeof(struct amdgpu_sa_bo), GFP_KERNEL);
-	if ((*sa_bo) == NULL) {
+	if (!(*sa_bo))
 		return -ENOMEM;
-	}
 	(*sa_bo)->manager = sa_manager;
 	(*sa_bo)->fence = NULL;
 	INIT_LIST_HEAD(&(*sa_bo)->olist);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index ee6a48a..6c020ea7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -3905,7 +3905,7 @@ static int gfx_v8_0_init_save_restore_list(struct amdgpu_device *adev)
 	int list_size;
 	unsigned int *register_list_format =
 		kmalloc(adev->gfx.rlc.reg_list_format_size_bytes, GFP_KERNEL);
-	if (register_list_format == NULL)
+	if (!register_list_format)
 		return -ENOMEM;
 	memcpy(register_list_format, adev->gfx.rlc.register_list_format,
 			adev->gfx.rlc.reg_list_format_size_bytes);
-- 
1.7.9.5

