Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34248 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbdIWTpj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:45:39 -0400
Received: by mail-pg0-f68.google.com with SMTP id u18so2597144pgo.1
        for <linux-media@vger.kernel.org>; Sat, 23 Sep 2017 12:45:39 -0700 (PDT)
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging/atomisp: make six local functions static to appease sparse
Date: Sun, 24 Sep 2017 01:15:34 +0530
Message-Id: <20170923194534.27020-1-falakreyaz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions __bo_alloc, __bo_search_and_remove_from_free_rbtree,
__bo_search_by_addr, __bo_search_by_addr_in_range, __bo_break_up and
__bo_merge  are local to the source and do not need to be in the global
scope, so make them static.

Cleans up sparse warnings:

warning: symbol '__bo_alloc' was not declared. Should it be static?
warning: symbol '__bo_search_and_remove_from_free_rbtree' was not declared. Should it be static?
warning: symbol '__bo_search_by_addr' was not declared. Should it be static?
warning: symbol '__bo_search_by_addr_in_range' was not declared. Should it be static?
warning: symbol '__bo_break_up' was not declared. Should it be static?
warning: symbol '__bo_merge' was not declared. Should it be static?
Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index 11162f595fc7..59905969df23 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -58,7 +58,7 @@ static unsigned int nr_to_order_bottom(unsigned int nr)
 	return fls(nr) - 1;
 }
 
-struct hmm_buffer_object *__bo_alloc(struct kmem_cache *bo_cache)
+static struct hmm_buffer_object *__bo_alloc(struct kmem_cache *bo_cache)
 {
 	struct hmm_buffer_object *bo;
 
@@ -99,7 +99,7 @@ static int __bo_init(struct hmm_bo_device *bdev, struct hmm_buffer_object *bo,
 	return 0;
 }
 
-struct hmm_buffer_object *__bo_search_and_remove_from_free_rbtree(
+static struct hmm_buffer_object *__bo_search_and_remove_from_free_rbtree(
 				struct rb_node *node, unsigned int pgnr)
 {
 	struct hmm_buffer_object *this, *ret_bo, *temp_bo;
@@ -150,7 +150,7 @@ struct hmm_buffer_object *__bo_search_and_remove_from_free_rbtree(
 	return temp_bo;
 }
 
-struct hmm_buffer_object *__bo_search_by_addr(struct rb_root *root,
+static struct hmm_buffer_object *__bo_search_by_addr(struct rb_root *root,
 							ia_css_ptr start)
 {
 	struct rb_node *n = root->rb_node;
@@ -175,8 +175,8 @@ struct hmm_buffer_object *__bo_search_by_addr(struct rb_root *root,
 	return NULL;
 }
 
-struct hmm_buffer_object *__bo_search_by_addr_in_range(struct rb_root *root,
-					unsigned int start)
+static struct hmm_buffer_object *__bo_search_by_addr_in_range(
+		struct rb_root *root, unsigned int start)
 {
 	struct rb_node *n = root->rb_node;
 	struct hmm_buffer_object *bo;
@@ -258,7 +258,7 @@ static void __bo_insert_to_alloc_rbtree(struct rb_root *root,
 	rb_insert_color(&bo->node, root);
 }
 
-struct hmm_buffer_object *__bo_break_up(struct hmm_bo_device *bdev,
+static struct hmm_buffer_object *__bo_break_up(struct hmm_bo_device *bdev,
 					struct hmm_buffer_object *bo,
 					unsigned int pgnr)
 {
@@ -331,7 +331,7 @@ static void __bo_take_off_handling(struct hmm_buffer_object *bo)
 	}
 }
 
-struct hmm_buffer_object *__bo_merge(struct hmm_buffer_object *bo,
+static struct hmm_buffer_object *__bo_merge(struct hmm_buffer_object *bo,
 					struct hmm_buffer_object *next_bo)
 {
 	struct hmm_bo_device *bdev;
-- 
2.12.1
